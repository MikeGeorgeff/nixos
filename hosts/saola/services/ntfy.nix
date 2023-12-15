{ config, pkgs, ... }:
{
  services.ntfy-sh = {
    enable = true;

    settings = {
      base-url = "https://ntfy.georgeff.co";
      listen-http = ":2586";
      behind-proxy = true;
    };
  };
}
