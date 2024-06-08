{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.nerdfonts ];

  fonts.packages = [ pkgs.nerdfonts ];
}
