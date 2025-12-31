{ pkgs, ... }:

{
  boot.kernelParams = [
    "i8042.reset"
    "i8042.nomux"
    "i8042.nopnp"
    "i8042.kbdreset"
    "acpi_osi=Linux"
    "mem_sleep_default=deep"
  ];

  powerManagement.enable = true;
  powerManagement.resumeCommands =
    "${pkgs.kmod}/bin/rmmod atkbd; ${pkgs.kmod}/bin/modprobe atkbd reset=1";

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
  };

  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    acpi
    powertop
  ];

  system.stateVersion = "25.11";
}
