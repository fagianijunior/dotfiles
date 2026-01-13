{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hardware.rocm;
in
{
  options.hardware.rocm = {
    enable = mkEnableOption "ROCm (Radeon Open Compute) support";

    supportedGPUs = mkOption {
      type = types.listOf types.str;
      default = [ "gfx1032" ]; # RX 6600 RDNA 2
      description = "List of supported GPU architectures";
    };

    environmentVariables = mkOption {
      type = types.attrsOf types.str;
      default = {
        HSA_OVERRIDE_GFX_VERSION = "10.3.0";
      };
      description = "ROCm environment variables for compatibility";
    };

    driverPriority = mkOption {
      type = types.bool;
      default = true;
      description = "Set ROCm as priority GPU compute driver and disable conflicting drivers";
    };

    conflictDetection = mkOption {
      type = types.bool;
      default = true;
      description = "Enable automatic detection and resolution of driver conflicts";
    };
  };

  config = mkIf cfg.enable {
    # Driver priority and conflict resolution
    assertions = mkIf cfg.conflictDetection [
      {
        assertion = !(any (driver: driver == "nvidia") (config.services.xserver.videoDrivers or [ ]));
        message = "ROCm conflicts with NVIDIA drivers. Please disable NVIDIA drivers when using ROCm.";
      }
      {
        assertion = !(any (mod: mod == "amdgpu") (config.boot.blacklistedKernelModules or [ ]));
        message = "amdgpu kernel module is blacklisted but required for ROCm. Please remove from blacklistedKernelModules.";
      }
    ];

    # Blacklist conflicting drivers when driver priority is enabled
    boot.blacklistedKernelModules = mkIf cfg.driverPriority [
      "nouveau" # Open source NVIDIA driver
      "nvidia" # Proprietary NVIDIA driver
      "nvidia_drm" # NVIDIA DRM module
      "nvidia_modeset" # NVIDIA mode setting
      "radeon" # Legacy AMD driver (conflicts with amdgpu)
    ];

    # Ensure ROCm-compatible drivers take priority and are loaded
    boot.kernelModules = [ "amdgpu" ];

    # Force amdgpu driver for AMD cards when priority is enabled
    services.xserver.videoDrivers = mkIf cfg.driverPriority (mkForce [ "amdgpu" ]);

    # Enable ROCm runtime and libraries
    systemd.tmpfiles.rules = [
      "d /dev/dri 0755 root root -"
    ];

    # ROCm packages
    environment.systemPackages =
      with pkgs.rocmPackages;
      [
        rocm-runtime
        rocm-device-libs
        rocm-smi
        rocminfo
        hip-common
        hipcc
      ]
      ++ (with pkgs; [
        clinfo
      ])
      ++ (
        if cfg.conflictDetection then
          [
            # Driver conflict detection script
            (pkgs.writeShellScriptBin "rocm-check-conflicts" ''
              #!/bin/bash

              echo "ROCm Driver Conflict Detection"
              echo "=============================="

              # Check for loaded conflicting modules
              conflicting_modules=("nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" "radeon")
              conflicts_found=false

              for module in "''${conflicting_modules[@]}"; do
                if lsmod | grep -q "^$module "; then
                  echo "WARNING: Conflicting module '$module' is loaded"
                  conflicts_found=true
                fi
              done

              # Check if amdgpu is loaded
              if ! lsmod | grep -q "^amdgpu "; then
                echo "ERROR: amdgpu module is not loaded"
                conflicts_found=true
              else
                echo "OK: amdgpu module is loaded"
              fi

              # Check ROCm device availability
              if [ ! -e /dev/kfd ]; then
                echo "ERROR: /dev/kfd device not found"
                conflicts_found=true
              else
                echo "OK: /dev/kfd device available"
              fi

              # Check for render devices
              render_devices=$(ls /dev/dri/renderD* 2>/dev/null | wc -l)
              if [ "$render_devices" -eq 0 ]; then
                echo "ERROR: No render devices found in /dev/dri/"
                conflicts_found=true
              else
                echo "OK: Found $render_devices render device(s)"
              fi

              if [ "$conflicts_found" = true ]; then
                echo ""
                echo "RESULT: Driver conflicts detected!"
                echo "Please check your configuration and reboot if necessary."
                exit 1
              else
                echo ""
                echo "RESULT: No driver conflicts detected."
                echo "ROCm should be working correctly."
                exit 0
              fi
            '')
          ]
        else
          [ ]
      );

    # System-wide environment variables for ROCm
    environment.variables = cfg.environmentVariables;

    # Ensure environment variables are available system-wide including for sudo
    environment.sessionVariables = cfg.environmentVariables;

    # Set environment variables for systemd services and global environment
    systemd.globalEnvironment = cfg.environmentVariables;

    # Alternative method: Use systemd environment.d for global environment
    environment.etc."systemd/system.conf.d/rocm-environment.conf" = {
      text = ''
        [Manager]
        ${concatStringsSep "\n" (
          mapAttrsToList (name: value: "DefaultEnvironment=${name}=${value}") cfg.environmentVariables
        )}
      '';
      mode = "0644";
    };

    # Configure shell profiles to ensure environment variables are available in all shell contexts
    environment.etc."profile.d/rocm.sh" = {
      text = ''
        # ROCm environment variables for system-wide availability
        ${concatStringsSep "\n" (
          mapAttrsToList (name: value: "export ${name}=${value}") cfg.environmentVariables
        )}
      '';
      mode = "0644";
    };

    # Configure PAM environment to ensure variables are available across all login contexts
    security.pam.loginLimits = [ ];
    environment.etc."environment".text = concatStringsSep "\n" (
      mapAttrsToList (name: value: "${name}=${value}") cfg.environmentVariables
    );

    # GPU device access permissions
    services.udev.extraRules = ''
      # ROCm GPU access
      SUBSYSTEM=="drm", KERNEL=="renderD*", GROUP="video", MODE="0664"
      SUBSYSTEM=="kfd", KERNEL=="kfd", GROUP="video", MODE="0664"
    '';

    # Add user to video group for GPU access
    users.groups.video = { };

    # ROCm-specific kernel parameters
    boot.kernelParams = [
      "amdgpu.dcdebugmask=0x10"
    ];

    # Enable hardware acceleration
    hardware.graphics = {
      extraPackages = with pkgs.rocmPackages; [
        rocm-runtime
      ];
    };
  };
}
