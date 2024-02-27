{ config, pkgs, ... }:
let
  domain = "woodpecker.georgeff.co";
  port = "3007";
  secrets = import ../../../secrets/woodpecker.nix;
in
{
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

  services.woodpecker-agents.agents = {
    "blackhawk" = {
      enable = true;
      extraGroups = [ "docker" ];
      environment = {
        WOODPECKER_SERVER = "127.0.0.1:9000";
        WOODPECKER_MAX_WORKFLOWS = "5";
        DOCKER_HOST = "unix:///var/run/docker.sock";
        WOODPECKER_BACKEND = "docker";
        WOODPECKER_AGENT_SECRET = "${secrets.agent.secret}";
      };
    };

    "red-wing" = {
      enable = true;
      extraGroups = [ "docker" ];
      environment = {
        WOODPECKER_SERVER = "127.0.0.1:9000";
        WOODPECKER_MAX_WORKFLOWS = "5";
        DOCKER_HOST = "unix:///var/run/docker.sock";
        WOODPECKER_BACKEND = "docker";
        WOODPECKER_AGENT_SECRET = "${secrets.agent.secret}";
      };
    };
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "georgeff.co";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };
}
