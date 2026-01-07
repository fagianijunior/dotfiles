{ pkgs, ... }:
{
  # AI and ML services - mainly for desktop (Nobita)
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama;
      environmentVariables = {
        # ROCm environment for GPU acceleration
        HSA_OVERRIDE_GFX_VERSION = "10.3.0";
        ROC_ENABLE_PRE_VEGA = "1";
        
        # Additional ROCm environment variables for better GPU detection
        ROCR_VISIBLE_DEVICES = ""; # Let ROCm detect all available devices
        HIP_VISIBLE_DEVICES = "";  # Let HIP detect all available devices
        
        # Ollama-specific GPU configuration
        OLLAMA_DEBUG = "INFO";     # Enable debug logging for GPU detection
      };
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
      "/dev/dri rw"      # GPU device access
      "/dev/kfd rw"      # ROCm kernel fusion driver
    ];
    
    # Ensure ROCm environment is available to the service
    Environment = [
      "HSA_OVERRIDE_GFX_VERSION=10.3.0"
      "ROC_ENABLE_PRE_VEGA=1"
    ];
  };
}