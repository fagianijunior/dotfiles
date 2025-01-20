{
  description = "Configuração para duas máquinas diferentes.";
  
  nixConfig = {
    allowUnfree = true;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      nobita = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configurations/common.nix
          ./configurations/nobita.nix
        ];
      };

      doraemon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configurations/common.nix
          ./configurations/doraemon.nix
        ];
      };
    };

    homeConfigurations = {
      "terabytes@nobita" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [ ./configurations/terabytes-home.nix ];
      };
    };
  };
}
