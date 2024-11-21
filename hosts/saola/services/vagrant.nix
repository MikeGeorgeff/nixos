{ config, pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;

  users.users.admin.extraGroups = [ "libvirtd" ];

  environment.systemPackages = [ pkgs.vagrant ];
}
