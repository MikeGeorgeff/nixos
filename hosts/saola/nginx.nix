{ config, pkgs, ... }:
let
  porkbun = import ../../secrets/porkbun.nix;
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    clientMaxBodySize = "5000M";

    virtualHosts = {
      "saola.georgeff.co" = {
        forceSSL = true;
        useACMEHost = "georgeff.co";
        locations."/" = {
          proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "mike@georgeff.co";
      reloadServices = [ "nginx" ];
    };

    certs."georgeff.co" = {
      domain = "georgeff.co";
      extraDomainNames = [ "*.georgeff.co" ];
      dnsProvider = "porkbun";
      dnsPropagationCheck = true;
      credentialsFile = "${pkgs.writeText "porkbun-creds" ''
        PORKBUN_API_KEY=${porkbun.apiKey}
        PORKBUN_SECRET_API_KEY=${porkbun.secretKey}
      ''}";
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
