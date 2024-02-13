{ config, pkgs, ... }:
let
  stateDir = "/mnt/vault/services/gitea";
  domain = "git.georgeff.co";
in
{
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

  systemd.tmpfiles.rules = [
    "d ${stateDir} 0770 git git -"
  ];

  services.gitea = {
    enable = true;
    user = "git";
    group = "git";
    stateDir = "${stateDir}";

    settings = {
      server = {
        ROOT_URL = "https://${domain}";
        HTTP_PORT = 3000;
        SSH_PORT = 22;
      };

      session.COOKIE_SECURE = true;

      service.DISABLE_REGISTRATION = true;
    };
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "georgeff.co";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.gitea.settings.server.HTTP_PORT}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
