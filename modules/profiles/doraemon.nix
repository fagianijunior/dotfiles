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

  powerManagement.cpuFreqGovernor = "schedutil";

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
  };

  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-studio-plugins.droidcam-obs
    ];
  };

  environment.systemPackages = with pkgs; [
    acpi
    powertop
  ];
}
