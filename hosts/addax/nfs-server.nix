{ config, pkgs, ... }:
{
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
  ];

  services.nfs.server.exports = ''
    /mnt/vault/iso 10.10.2.0/24(rw,nohide,insecure,no_subtree_check) 10.10.3.0/24(rw,nohide,insecure,no_subtree_check) 100.97.94.63(rw,nohide,insecure,no_subtree_check) 100.88.169.90(rw,nohide,insecure,no_subtree_check)
  '';
}
