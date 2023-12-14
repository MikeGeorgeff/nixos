{ config, ... }:
{
  fileSystems."/mnt/storage" = {
    device = "10.10.3.10:/mnt/vault/storage";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
  };
}
