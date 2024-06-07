{ config, pkgs, ... }:
{
  services.xserver.dpi = 144;

  environment.variables = {
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1";
  };
}
