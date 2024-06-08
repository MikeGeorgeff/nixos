{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zfs
    btop
    rsync
  ];
}
