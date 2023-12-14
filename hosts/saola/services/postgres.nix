{ config, pkgs, ... }:
let
  backupDir = "/mnt/backups/database";
  tailscaleIP = "100.122.158.125";
in
{
  fileSystems = {
    "${backupDir}" = {
      device = "10.10.3.10:/mnt/vault/backups/database";
      fsType = "nfs";
      options = [ "nfsvers=4.2" ];
    };
  };

  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
      authentication = ''
        #type database DBuser auth-method
        local all      all    trust
      '';
    };

    postgresqlBackup = {
      enable = true;
      location = "${backupDir}";
      backupAll = true;
    };
  };
}