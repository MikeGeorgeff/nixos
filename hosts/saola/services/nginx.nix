{ config, pkgs, ... }:
let
  porkbun = import ../../../secrets/porkbun.nix;
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    virtualHosts = {
      "git.georgeff.co" = {
        forceSSL = true;
        useACMEHost = "georgeff.co";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      "speedtest.georgeff.co" = {
        forceSSL = true;
        useACMEHost = "georgeff.co";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8002";
          recommendedProxySettings = true;
        };
      };

      "ntfy.georgeff.co" = {
        forceSSL = true;
        useACMEHost = "georgeff.co";
        locations."/" = {
          proxyPass = "http://127.0.0.1:2586";
          recommendedProxySettings = true;
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
        PORKBUN_API_KEY=${porkbun.api-key}
        PORKBUN_SECRET_API_KEY=${porkbun.api-secret-key}
      ''}";
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
