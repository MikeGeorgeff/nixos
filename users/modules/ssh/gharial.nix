{ config, ... }:
{
  home.file = {
     ".ssh/config".source = ./config;
     ".ssh/id_ed25519".source = ../../../secrets/id_ed25519-admin_gharial;
  };
}
