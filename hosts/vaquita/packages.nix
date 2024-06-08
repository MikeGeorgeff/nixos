{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    htop
    ethtool
    tcpdump
    contrack-tools
  ];
}
