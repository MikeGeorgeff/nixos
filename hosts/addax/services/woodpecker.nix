{ config, pkgs, ... }:
let
  secrets = import ../../../secrets/woodpecker.nix;
  domain = "woodpecker.georgeff.co";
  port = "3001";
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
      extraGroups = [ "podman" ];
      environment = {
        WOODPECKER_SERVER = "localhost:9000";
        WOODPECKER_MAX_WORKFLOWS = "5";
        DOCKER_HOST = "unix:///run/podman/podman.sock";
        WOODPECKER_BACKEND = "docker";
        WOODPECKER_AGENT_SECRET = "${secrets.agent.secret}";
        WOODPECKER_DOCKER_CONFIG = "/home/admin/.docker/auth.json";
      };
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
