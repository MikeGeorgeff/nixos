{ config, ... }:
{
  home.file = {
    ".config/nitrogen/bg-saved.cfg".source = ./bg-saved.cfg;
    ".config/nitrogen/nitrogen.cfg".source = ./nitrogen.cfg;
    ".config/nitrogen/wallpaper" = {
      source = ./wallpaper;
      recursive = true;
    };
  };
}