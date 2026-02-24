{ ... }:

{
  nix = {
    optimise = {
      automatic = true; # Enable automatic optimization.
      dates = "weekly"; # Set optimization period to weekly.
    };

    settings = {
      # Enable experimental features and set trusted users for Nix.
      # Used to build OrangePiZero2 and other ARM64 devices.
      extra-platforms = [ "aarch64-linux" ];

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
