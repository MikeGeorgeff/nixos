{ config, pkgs, ... }:
{
    imports = [
        ./modules/ssh/default.nix
        ../modules/git/default.nix
        ../modules/neofetch/default.nix
        ../modules/zsh/default.nix
        ../modules/nvim/default.nix
    ];

    home.username = "admin";
    home.homeDirectory = "/home/admin";
    home.packages = with pkgs; [
      btop
      bat
      neofetch
      thefuck
      eza
      zsh
      lazygit
    ];

    home.stateVersion = "23.11";

    programs.home-manager.enable = true;
}
