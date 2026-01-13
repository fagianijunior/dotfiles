{ pkgs, ... }:
{
  # AI and ML services - mainly for desktop (Nobita)
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      environmentVariables = {
        HCC_AMDGPU_TARGET = "gfx1031"; # used to be necessary, but doesn't seem to anymore
        # ROCm environment for GPU acceleration
        HSA_OVERRIDE_GFX_VERSION = "10.3.0";

        # Additional ROCm environment variables for better GPU detection
        ROCR_VISIBLE_DEVICES = "0";
        HIP_VISIBLE_DEVICES = "0";
        OLLAMA_LLM_LIBRARY = "rocm";

        # Ollama-specific GPU configuration
        OLLAMA_DEBUG = "DEBUG"; # Enable debug logging for GPU detection
      };
      # results in environment variable "HSA_OVERRIDE_GFX_VERSION=10.3.0"
      rocmOverrideGfx = "10.3.0";
    };

    qdrant = {
      enable = true;
      webUIPackage = pkgs.qdrant-web-ui;
      settings = {
        service.host = "0.0.0.0";
        # service.port = 6333;
        # service.grpc_port = 6334;
      };
    };
  };

  # Ensure ollama user has access to GPU devices
  systemd.services.ollama.serviceConfig = {
    SupplementaryGroups = [ "video" ];

    # Additional service configuration for GPU access
    DeviceAllow = [
      "/dev/dri rw" # GPU device access
      "/dev/kfd rw" # ROCm kernel fusion driver
    ];

    # Ensure ROCm environment is available to the service
    Environment = [
      "HSA_OVERRIDE_GFX_VERSION=10.3.0"
    ];
  };
}
