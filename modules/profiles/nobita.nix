{ pkgs, ... }:
{
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama;
    };

    qdrant = {
      enable = true;
      webUIPackage = pkgs.qdrant-web-ui;
      settings = {
        # Set the service to listen on all interfaces (0.0.0.0)
        service.host = "0.0.0.0";
        # The default port is usually 6333 for the API and 6334 for the gRPC interface
        # You may also want to explicitly set ports if needed
        # service.port = 6333;
        # service.grpc_port = 6334;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # coisas que só fazem sentido em desktop fixo
    legendary-gl
    heroic
    nile
  ];

  programs = {
    steam = {
      enable = true;
      extraPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamescope.enable = true;
  };
}
