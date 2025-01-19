{
  description = "Configuração para duas máquinas diferentes.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  nixConfig = {
    allowUnfree = true;
  };
  
  outputs = { self, nixpkgs, ... }: {
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
  };
}
