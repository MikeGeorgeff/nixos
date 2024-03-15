{ config, pkgs, ... }:
{
    programs.zsh = {
        enable = true;
        dotDir = ".config/zsh";
        enableAutosuggestions = true;

        shellAliases = {
            ls = "eza -la --color=always --group-directories-first";
            la = "eza -a --color=always --group-directories-first";
            ll = "eza -l --color=always --group-directories-first";
            lt = "eza -aT --color=always --group-directories-first";
            cat = "bat";
            lg = "lazygit";
            fm = "vifm";
            shutdown = "sudo shutdown now";
            reboot = "sudo reboot";
            ssh-pubkey = "ssh-keygen -f $HOME/.ssh/id_ed25519 -y";
        };

        initExtraFirst = ''
            neofetch
        '';

        initExtra = ''
            eval $(thefuck --alias)
            source $HOME/.config/zsh/steeef.zsh-theme
        '';

        plugins = with pkgs; [
            {
                name = "zsh-syntax-highlighting";
                src = fetchFromGitHub {
                    owner = "zsh-users";
                    repo = "zsh-syntax-highlighting";
                    rev = "0.7.1";
                    sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
                };
                file = "zsh-syntax-highlighting.zsh";
            }
        ];

        history = {
            path = "$ZDOTDIR/.zsh_history";
            size = 100000;
            save = 100000;
        };
    };

    home.file.".config/zsh/steeef.zsh-theme".source = ./steeef.zsh-theme;
}
