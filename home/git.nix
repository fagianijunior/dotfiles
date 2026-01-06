{ ... }:

{
  programs.delta = {
    enable = true;
    options = {
      syntax-theme = "Catppuccin-macchiato";
      navigate = true;
    };
  };
  programs.git = {
    enable = true;

    settings = {

      user.name = "Carlos Fagiani Junior";
      user.email = "fagianijunior@gmail.com";

      init.defaultBranch = "main";

      core = {
        editor = "nvim";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
      };

      pull.rebase = true;

      push.autoSetupRemote = true;

      fetch = {
        prune = true;
        pruneTags = true;
      };

      rebase.autoStash = true;

      merge.conflictStyle = "zdiff3";

      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };

      rerere.enabled = true;

      status.branch = true;

      log.date = "iso";

      credential.helper = "";

      # Força SSH
      url = {
        "git@github.com:".insteadOf = "https://github.com/";
        "git@gitlab.com:".insteadOf = "https://gitlab.com/";
      };

      aliases = {
        st = "status -sb";
        co = "checkout";
        br = "branch";
        ci = "commit";
        lg = "log --oneline --decorate --graph --all";
        amend = "commit --amend --no-edit";
        undo = "reset --soft HEAD~1";
      };
    };

    ignores = [
      ".direnv"
      ".env"
      ".env.local"
      "result"
      "*.log"
      ".DS_Store"
    ];
  };
}
