{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode; # oficial
    mutableExtensionsDir = true;

    profiles.default = {
      userSettings = {
        ########################################
        # Core behavior
        ########################################
        "update.mode" = "none";
        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = false;

        ########################################
        # Files / Watchers (NixOS fix clássico)
        ########################################
        "files.watcherExclude" = {
          "**/.git/objects/**" = true;
          "**/.git/subtree-cache/**" = true;
          "**/node_modules/**" = true;
          "**/.direnv/**" = true;
          "**/result/**" = true;
          "**/nix/store/**" = true;
        };

        ########################################
        # Editor
        ########################################
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = false;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.rulers" = [ 100 ];
        "editor.minimap.enabled" = false;
        "editor.stickyScroll.enabled" = true;
        "editor.smoothScrolling" = true;
        "editor.mouseWheelZoom" = true;
        "terminal.integrated.gpuAcceleration" = "on";
        "window.experimental.useSandbox" = false;

        ########################################
        # Search / Performance
        ########################################
        "search.followSymlinks" = false;
        "search.exclude" = {
          "**/node_modules" = true;
          "**/vendor" = true;
          "**/.git" = true;
          "**/result" = true;
        };

        ########################################
        # Terminal (NixOS critical)
        ########################################
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.inheritEnv" = false;
        "terminal.integrated.env.linux" = {
          "NIXPKGS_ALLOW_UNFREE" = "1";
        };

        ########################################
        # Git
        ########################################
        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
        "git.autofetch" = true;

        ########################################
        # Language servers – evita conflito
        ########################################
        "python.analysis.autoImportCompletions" = true;
        "python.analysis.typeCheckingMode" = "basic";

        ########################################
        # Terraform
        ########################################
        "terraform.languageServer" = {
          "external" = true;
          "path" = "terraform-ls";
        };

        ########################################
        # Nix IDE
        ########################################
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "nixpkgs-fmt";

        ########################################
        # Remote SSH (evita bug comum)
        ########################################
        "remote.SSH.useLocalServer" = false;
        "remote.SSH.connectTimeout" = 60;

        ########################################
        # Wayland / NixOS
        ########################################
        "window.titleBarStyle" = "custom";
        "window.menuBarVisibility" = "toggle";

        ########################################
        # Kilo Code
        ########################################
        "kilo-code.allowedCommands" = [
          "git log"
          "git diff"
          "git show"
        ];
        "kilo-code.deniedCommands" = [
          "terrafomr init"
          "terraform apply"
          "terraform plan"
        ];

        ########################################
        # Amazon Q
        ########################################
        "amazonQ.suppressPrompts" = {
          "amazonQChatDisclaimer" = true;
        };

        ########################################
        # UI polish (Wayland friendly)
        ########################################
        "editor.fontLigatures" = true;
        "editor.renderWhitespace" = "boundary";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.cursorBlinking" = "smooth";

        "workbench.sideBar.location" = "left";
        "workbench.editor.labelFormat" = "short";
        "workbench.editor.enablePreview" = false;

        "window.commandCenter" = true;

        "gitlens.ai.model" = "vscode";
      };
      extensions = with pkgs.vscode-extensions; [
        hashicorp.terraform
        bbenoist.nix
        jnoortheen.nix-ide
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        shopify.ruby-lsp
        ms-vscode.makefile-tools
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.remote-explorer
        amazonwebservices.amazon-q-vscode
        eamodio.gitlens
        kilocode.kilo-code
      ];
    };
  };
}
