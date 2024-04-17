{ config, pkgs, ... }:
{
  imports = [
    ./pkgs.default.nix
    ./pkgs.desktop.nix
    ../modules/ssh/condor.nix
    ../modules/git/default.nix
    ../modules/neofetch/default.nix
    ../modules/zsh/default.nix
    ../modules/nvim/default.nix
    ../modules/alacritty/default.nix
    ../modules/i3/default.nix
    ../modules/nitrogen/default.nix
  ];

  home.username = "admin";
  home.homeDirectory = "/home/admin";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
