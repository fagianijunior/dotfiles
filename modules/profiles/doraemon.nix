{ pkgs, ... }:
{
  # Laptop-specific kernel parameters for better hardware support
  boot.kernelParams = [
    "i8042.reset"
    "i8042.nomux"
    "i8042.nopnp"
    "i8042.kbdreset"
    "acpi_osi=Linux"
    "mem_sleep_default=deep"
  ];

  # Power management optimized for laptop
  powerManagement.cpuFreqGovernor = "schedutil";

  # Lid switch behavior
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
  };

  # OBS Studio for content creation
  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-studio-plugins.droidcam-obs
    ];
  };

  # Laptop-specific utilities
  environment.systemPackages = with pkgs; [
    acpi
    powertop
  ];
}
