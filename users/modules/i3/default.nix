{ config, ... }:
{
  home.file = {
    ".config/i3/config".source = ./i3_config;
    ".config/i3status/config".source = ./i3status_config;
  };
}