{
  description = "Configuração para duas máquinas diferentes.";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = inputs@{ self, nixpkgs, systems, home-manager, ... }: {
    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
      settings = {
        auto-optimise-store = true;
      };
    };
    
    nixosConfigurations = {
      nobita = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configurations/common.nix
          ./configurations/nobita.nix
          home-manager.nixosModules.home-manager {
            home-manager.backupFileExtension = "back.tar.gz";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.terabytes = import ./configurations/terabytes-home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

      doraemon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configurations/common.nix
          ./configurations/doraemon.nix
          home-manager.nixosModules.home-manager {
            home-manager.backupFileExtension = "back.tar.gz";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.terabytes = import ./configurations/terabytes-home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
