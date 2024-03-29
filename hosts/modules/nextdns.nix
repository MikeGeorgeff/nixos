{ config, pkgs, ...}:
{
  services.nextdns.enable = true;
  services.nextdns.arguments = [
    "-profile"
    "d76f76"
    "-cache-size"
    "10MB"
    "-listen"
    "0.0.0.0:53"
    "-report-client-info"
    "-auto-activate"
  ];

  environment.systemPackages = [
    pkgs.nextdns
  ];
}
