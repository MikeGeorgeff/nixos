{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    btop
    bat
    neofetch
    thefuck
    eza
    zsh
    lazygit
    vifm-full
    devenv
    k9s
  ];
}
