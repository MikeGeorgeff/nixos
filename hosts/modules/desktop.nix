{ config, pkgs, ... }:
{
  sound.enable = true;

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";

      windowManager.i3 = {
        enable = true;
        extraPackages = [ pkgs.i3status ];
      };

      desktopManager.xterm.enable = false;

      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+i3";
      };

      libinput = {
        enable = true;

        touchpad = {
          tapping = false;
          disableWhileTyping = true;
          clickMethod = "clickfinger";
        };
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    printing.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  environment.systemPackages = with pkgs; [
    arandr
    curl
    dmenu
    git
    gnome.gnome-keyring
    nerdfonts
    networkmanagerapplet
    nitrogen
    pasystray
    picom
    polkit_gnome
    pulseaudioFull
    rofi
    wget
    unrar
    unzip
    p7zip
  ];

  programs = {
    thunar.enable = true;
    dconf.enable = true;
    zsh.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware.bluetooth.enable = true;

  fonts.packages = [
    pkgs.nerdfonts
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
