{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Configuração para Orange Pi Zero 2 (Allwinner H616, ARM64 Cortex-A53)
  boot.initrd.availableKernelModules = [ "sunxi_mmc" "dm_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "sunxi" "dwmac_sun8i" "phy_sun4i_usb" ];
  boot.extraModulePackages = [ ];

  # Sistema de arquivos
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "x-initrd.mount" ];
  };

  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    options = [ "nofail" "noauto" ];
  };

  swapDevices = [ ];

  # Configuração específica para ARM64
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # Suporte a hardware
  hardware.enableRedistributableFirmware = true;
}
