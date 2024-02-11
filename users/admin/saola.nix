{ config, pkgs, ... }:
{
  imports = [
    ./pkgs.default.nix
    ../modules/ssh/saola.nix
    ../modules/git/default.nix
    ../modules/neofetch/default.nix
    ../modules/zsh/default.nix
    ../modules/nvim/default.nix
  ];

  home.username = "admin";
  home.homeDirectory = "/home/admin";  

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
