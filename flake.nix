{
  description = "NixOS config - doraemon & nobita";

  inputs = {
    # Using nixos-unstable:
    #   - Provides the latest packages and features.
    #   - Be aware that occasional breaking changes might occur.
    #   - For better reproducibility, regularly run `nix flake update` to refresh flake.lock,
    #     or pin nixpkgs to a specific commit if stability issues arise.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      flake-utils,
      catppuccin,
      ...
    }:
    let
      lib = nixpkgs.lib;

      mkHost =
        {
          hostname,
          system ? "x86_64-linux",
        }:
        lib.nixosSystem {
          inherit system;

          modules = [
            ./hosts/${hostname}.nix

            # Catppuccin
            catppuccin.nixosModules.catppuccin

            # Home Manager
            home-manager.nixosModules.home-manager

            (
              { pkgs, ... }:
              {
                networking.hostName = hostname;

                nixpkgs.config.allowUnfree = true;

                nixpkgs.overlays = [
                  (import ./pkgs/overlays.nix)
                ];

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.backupFileExtension = "back.tar.gz";

                home-manager.users.terabytes = {
                  imports = [
                    catppuccin.homeModules.catppuccin
                    ./home/default.nix
                  ];

                  catppuccin = {
                    enable = true;
                    flavor = "macchiato";

                    rofi = {
                      enable = true;
                    };
                  };
                };
              }
            )
          ];
        };

      # Configuração simplificada para servidor (sem home-manager)
      mkServer =
        {
          hostname,
          system ? "aarch64-linux",
          configPath,
        }:
        lib.nixosSystem {
          inherit system;

          modules = [
            configPath

            (
              { pkgs, ... }:
              {
                networking.hostName = hostname;
                nixpkgs.config.allowUnfree = true;

                nixpkgs.overlays = [
                  (import ./pkgs/overlays.nix)
                ];
              }
            )
          ];
        };
    in
    {
      nixosConfigurations = {
        doraemon = mkHost { hostname = "doraemon"; };
        nobita = mkHost { hostname = "nobita"; };
        orangepizero2 = mkServer {
          hostname = "orangepizero2";
          system = "aarch64-linux";
          configPath = ./nixos-orangepizero2/orangepizero2.nix;
        };
      };
    };
}
