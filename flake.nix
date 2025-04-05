{
  description = "Configuração para duas máquinas diferentes.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    mkNixosConfiguration = { system, modules }:
      nixpkgs.lib.nixosSystem {
        inherit system modules;
      };

    commonModules = [
      ./configurations/common.nix
      home-manager.nixosModules.home-manager {
        home-manager.backupFileExtension = "back.tar.gz";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.terabytes = import ./configurations/terabytes-home.nix;
        nix = {
          settings = {
            experimental-features = [ "nix-command" "flakes" ];
            auto-optimise-store = true;
          };
        };
      }
    ];
  in
  {
    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    nixosConfigurations = {
      nobita = mkNixosConfiguration {
        system = "x86_64-linux";
        modules = commonModules ++ [ ./configurations/nobita.nix ];
      };

      doraemon = mkNixosConfiguration {
        system = "x86_64-linux";
        modules = commonModules ++ [ ./configurations/doraemon.nix ];
      };
    };
  };
}
