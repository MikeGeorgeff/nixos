{ config, pkgs, ... }:
{
  services.xserver.dpi = 180;

  environment.variables = {
    GDK_SCALE = "0.8";
    GDK_DPI_SCALE = "0.8";
  };
}
