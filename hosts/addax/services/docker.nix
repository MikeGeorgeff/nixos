{ config, pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  virtualisation.oci-containers.backend = "docker";

  networking.firewall.interfaces."podman0" = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
}
