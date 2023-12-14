{ config, pkgs, ... }:
{
    imports = [
        ./modules/alacritty/default.nix
        ./modules/i3/default.nix
        ./modules/nitrogen/default.nix
        ./modules/ssh/default.nix
        ../modules/git/default.nix
        ../modules/neofetch/default.nix
        ../modules/zsh/default.nix
        ../modules/nvim/default.nix
    ];

    home = {
        username = "mike";
        homeDirectory = "/home/mike";

        packages = with pkgs; [
            alacritty
            btop
            brave
            bitwarden
            bat
            eza
            slack
            insomnia
            obsidian
            thefuck
            neofetch
            zsh
            lazygit
            flameshot
        ];

        stateVersion = "23.05";
    };

    programs.home-manager.enable = true;
}
