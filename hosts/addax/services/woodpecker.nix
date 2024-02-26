{ config, pkgs, ... }:
let
  secrets = import ../../../secrets/woodpecker.nix;
  domain = "woodpecker.georgeff.co";
  port = "3001";
in
{

  networking.firewall.allowedTCPPorts = [ 9000 ];

  services.woodpecker-server = {
    enable = true;
    environment = {
      WOODPECKER_HOST = "https://${domain}";
      WOODPECKER_SERVER_ADDR = ":${port}";
      WOODPECKER_OPEN = "true";
      WOODPECKER_ADMIN = "mike";
      WOODPECKER_GITEA = "true";
      WOODPECKER_GITEA_URL = "https://git.georgeff.co";
      WOODPECKER_GITEA_CLIENT = "${secrets.gitea.client.id}";
      WOODPECKER_GITEA_SECRET = "${secrets.gitea.client.secret}";
      WOODPECKER_AGENT_SECRET = "${secrets.agent.secret}";
    };
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "georgeff.co";
    locations."/" = {
      proxyPass = "http://localhost:${port}";
    };
  };
}
