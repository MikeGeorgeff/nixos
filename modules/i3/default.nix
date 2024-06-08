{ pkgs, ... }:
{
  services = {
    displayManager = {
      enable = true;
      defaultSession = "none+i3";
    };

    xserver = {
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
        ];
      };

      desktopManager.xterm.enable = false;
    };
  };
}
