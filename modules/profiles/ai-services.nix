{ pkgs, ... }:
{
  # AI and ML services - mainly for desktop (Nobita)
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama;
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
}