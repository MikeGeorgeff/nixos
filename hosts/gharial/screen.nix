{ config, pkgs, ... }:
{
  services.xserver.dpi = 144;

  environment.variables = {
    GDK_SCALE = "0.8";
    GDK_DPI_SCALE = "0.8";
  };
}
