{ config, pkgs, ... }:
let
  settings = import ../../../secrets/gitea.nix;

  url = "https://git.georgeff.co";
  token = settings.actions-runner.token;
in
{
  services.gitea-actions-runner.instances = {
    blackhawk = {
      enable = true;
      name = "blackhawk";
      url = "${url}";
      token = "${token}";
      labels = [ "native:host" "nixos" ];
    };

    bruin = {
      enable = true;
      name = "bruin";
      url = "${url}";
      token = "${token}";
      labels = [ "native:host" "nixos" ];
    };
  };
}
