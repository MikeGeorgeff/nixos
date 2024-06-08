{ ... }:
{
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=45.90.28.0#condor-d76f76.dns.nextdns.io
      DNS=45.90.30.0#condor-d76f76.dns.nextdns.io
      DNSOverTLS=yes
    '';
  };
}
