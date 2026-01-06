# shell.nix
{ pkgs, ... }:
{
  home.shellAliases = {
    cl = "clear";
    cat = "bat --style=numbers,changes --color=always";
    lgit = "lazygit";
    ldocker = "lazydocker";
  };

  programs = {
    fish = {
      enable = true;

      interactiveShellInit = ''
        # Disable greeting
        set fish_greeting

        # History tuning
        set -g fish_history_limit 10000

        # Better less
        set -gx LESS "-R --mouse"

        # AWS
        set -gx AWS_PAGER ""
        set -gx AWS_CLI_AUTO_PROMPT on-partial

        # Terraform
        set -gx TF_INPUT false
      '';

      functions = {
        nswitch = {
          description = "Rebuild NixOS usando o flake do host atual";
          body = ''
            sudo nixos-rebuild switch \
              --flake ~/Workspace/fagianijunior/dotfiles/#(hostname)
          '';
        };

        ngc = {
          body = "sudo nix-collect-garbage -d";
        };

        ngc7 = {
          body = "sudo nix-collect-garbage --delete-older-than 7d";
        };

        ngc14 = {
          body = "sudo nix-collect-garbage --delete-older-than 14d";
        };

        logitech-change-host = {
          description = "Troca o host dos dispositivos logitech entre nobita e doraemon";
          body = ''
            set normalized_hostname (echo $hostname | string lower)
            switch $normalized_hostname
              case "nobita"
                solaar config "LIFT" change-host "1"  # doraemon
                solaar config "Keyboard K380" change-host "1" # doraemon
              case "doraemon"
                solaar config "LIFT" change-host "3" # nobita
                solaar config "Keyboard K380" change-host "3" # nobita
              case "*"
                echo "Host desconhecido. Nenhuma alteração feita."
            end
          '';
        };

        aws-mfa = {
          description = "Gera credenciais temporárias AWS via MFA";
          body = ''
            if test (count $argv) -ne 1
              echo "Uso: aws-mfa <TOKEN_MFA>"
              return 1
            end

            set TOKEN_CODE $argv[1]

            set OUTPUT (aws sts get-session-token \
              --profile veezor \
              --duration-seconds 43200 \
              --serial-number arn:aws:iam::244589516718:mfa/carlos.fagiani \
              --token-code $TOKEN_CODE)

            if test $status -ne 0
              echo "Erro ao obter session token da AWS"
              return 1
            end

            set ACCESS_KEY_ID (echo $OUTPUT | jq -r '.Credentials.AccessKeyId')
            set SECRET_ACCESS_KEY (echo $OUTPUT | jq -r '.Credentials.SecretAccessKey')
            set SESSION_TOKEN (echo $OUTPUT | jq -r '.Credentials.SessionToken')

            aws configure set aws_access_key_id $ACCESS_KEY_ID --profile veezor-mfa
            aws configure set aws_secret_access_key $SECRET_ACCESS_KEY --profile veezor-mfa
            aws configure set aws_session_token $SESSION_TOKEN --profile veezor-mfa

            echo "Credenciais temporárias geradas para o perfil 'veezor-mfa' por 12 horas."
          '';
        };
      };

      plugins = [
        # fzf integration
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }

        # Notifications when done
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }

        # Colored output
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }

        # Better editing of pairs
        {
          name = "pisces";
          src = pkgs.fishPlugins.pisces.src;
        }
      ];
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };
}
