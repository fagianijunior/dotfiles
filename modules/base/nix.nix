{ ... }:

{
  nix = {
    
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "root" "terabytes" ];
      auto-optimise-store = true;

      warn-dirty = false;

      keep-derivations = true;
      keep-outputs = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
