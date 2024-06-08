{ config, pkgs, ... }:
let
  saola = "10.10.3.2";
  condor = "100.88.169.90";
  pangolin = "100.97.94.63";

  default = "rw,nohide,insecure,no_subtree_check";
in
{
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = true;

  fileSystems."/mnt/vault" = {
    device = "vault";
    fsType = "zfs";
  };

  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
  };

  networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];

  systemd.tmpfiles.rules = [
    "d /mnt/vault/iso 0770 admin users -"
    "d /mnt/vault/mike 0770 admin users -"
  ];

  services.nfs.server.exports = ''
    /mnt/vault/iso ${saola}(${default}) ${condor}(${default}) ${pangolin}(${default})
    /mnt/vault/mike ${pangolin}(${default}) ${condor}(${default})
  '';
}
