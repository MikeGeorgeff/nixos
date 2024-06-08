{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
    bat
    neofetch
    thefuck
    eza
    lazygit
    vifm-full
    curl
    git
    wget
    unrar
    unzip
    p7zip
  ];
}
