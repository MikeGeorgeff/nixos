{ config, pkgs, ... }:
let
  port = 8081;
in
{
  services.gotify = {
    enable = true;
    port = port;
  };

  services.nginx.virtualHosts."gotify.georgeff.co" = {
    forceSSL = true;
    useACMEHost = "georgeff.co";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };
}
