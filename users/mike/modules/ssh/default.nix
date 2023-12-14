{ config, ... }:
{
  home.file = {
    ".ssh/config".source = ../../../modules/ssh/config;
    ".ssh/id_ed25519".source = ../../../../secrets/id_ed25519-mike;
  };
}