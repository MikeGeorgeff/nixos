{ config, pkgs, ... }:
let
  config = import ../../../secrets/woodpecker.nix;
in
{
  services.woodpecker-server = {
    enable = true;

    environment = {
      WOODPECKER_HOST = "https://woodpecker.georgeff.co";
      WOODPECKER_SERVER_ADDR = ":3007";
      WOODPECKER_OPEN = "true";
      WOODPECKER_ADMIN = "mike";
      WOODPECKER_GITEA = "true";
      WOODPECKER_GITEA_URL = "https://git.georgeff.co";
      WOODPECKER_GITEA_CLIENT = "${config.gitea_client_id}";
      WOODPECKER_GITEA_SECRET = "${config.gitea_client_secret}";
    };
  };
}
