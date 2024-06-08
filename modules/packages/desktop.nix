{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    arandr
    dmenu
    gnome.gnome-keyring
    networkmanagerapplet
    pasystray
    picom
    rofi
  ];
}
