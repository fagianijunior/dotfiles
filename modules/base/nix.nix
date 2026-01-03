{ ... }:

{
  nix = {
    optimise = {
      automatic = true; # Enable automatic optimization.
      dates = "weekly"; # Set optimization period to weekly.
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "terabytes"
      ];
      auto-optimise-store = true;
      download-buffer-size = 524288000;

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
