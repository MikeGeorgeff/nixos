{ config, pkgs, ... }:
{
  fileSystems."/mnt/iso" = {
    device = "10.10.3.3:/mnt/vault/iso";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
  };
}
