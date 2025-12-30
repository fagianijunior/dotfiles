{ pkgs, ... }:

{
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "aco";
  };
}
