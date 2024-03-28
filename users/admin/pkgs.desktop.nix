{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    brave
    bitwarden
    slack
    insomnia
    flameshot
    rpi-imager
    arduino
    arduino-cli
    thonny
  ];
}
