{ config, pkgs, ... }:
let
  stateDir = "/mnt/vault/services/youtrack";
  domain = "youtrack.georgeff.co";
in
{
  systemd.tmpfiles.rules = [
    "d ${stateDir} 0750 youtrack youtrack -"
  ];

  services.youtrack = {
    enable = true;
    package = pkgs.youtrack;
    statePath = "${stateDir}";
    environmentalParameters = {
      base-url = "https://${domain}";
      listen-port = 8081;
    };
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "georgeff.co";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.youtrack.environmentalParameters.listen-port}";
    };
  };
}
