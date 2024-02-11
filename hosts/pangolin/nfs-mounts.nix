{ config, pkgs, ... }:
{
  fileSystems."/mnt/iso" = {
    device = "100.99.40.102:/mnt/vault/iso";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
  };
}
