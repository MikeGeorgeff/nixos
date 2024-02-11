{ config, pkgs, ... }:
let
  hostname = "condor";
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/openssh.nix
    ../modules/locale.nix
    ../modules/user-deploy.nix
    ../modules/tailscale.nix
    ../modules/nameservers-default.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
  };

  sound.enable = true;

  services = {
    xserver = {
      layout = "us";
      xkbVariant = "";
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
        ];
      };
      desktopManager = {
        xterm.enable = false;
      };
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
    printing.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  nixpkgs.config.pulseaudio = true;

  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nix.settings.trusted-users = [ "admin" ];

  security.sudo.wheelNeedsPassword = false;

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
    vim
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

  hardware = {
    bluetooth.enable = true;
  };

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11";
}
