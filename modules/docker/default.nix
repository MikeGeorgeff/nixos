{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  users.users.admin.extraGroups = [ "docker" ];

  environment.systemPackages = [ pkgs.docker-compose ];
}
