{ config, pkgs, ... }:
let
  stateDir = "/mnt/applications/gitea";
in
{
  fileSystems."${stateDir}" = {
    device = "10.10.3.10:/mnt/vault/applications/gitea";
    fsType = "nfs";
    options = [ "nfsvers=4.2" ];
  };

  users.users.git = {
    uid = 1003;
    isSystemUser = true;
    home = "${stateDir}";
    group = "git";
    useDefaultShell = true;
    extraGroups = [ "gitea" ];
  };

  users.groups.git = {
    gid = 1003;
  };

  services.postgresql = {
    ensureDatabases = [ "gitea" ];

    ensureUsers = [{
      name = "gitea";
      ensureDBOwnership = true;
    }];
  };

  services.gitea = {
    enable = true;
    user = "git";
    stateDir = "${stateDir}";

    database = {
      type = "postgres";
      socket = "/var/run/postgresql";
      user = "gitea";
      name = "gitea";
      createDatabase = false;
    };

    settings = {
      server = {
        ROOT_URL = "https://git.georgeff.co";
        HTTP_PORT = 3000;
        SSH_PORT = 22;
      };

      session = {
        COOKIE_SECURE = true;
      };

      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };
}
