{ config, pkgs, ... }:
let
  hostname = "pangolin";
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/openssh.nix
    ../modules/locale.nix
    ../modules/user-deploy.nix
    ../modules/tailscale.nix
    ./filesystem.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "${hostname}";
    nameservers = [
      "45.90.28.0#${hostname}-d76f76.dns.nextdns.io"
      "45.90.30.0#${hostname}-d76f76.dns.nextdns.io"
    ];
    extraHosts = ''
      10.10.3.2       saola
      100.113.14.81   saola.ts
      10.10.3.3       sawfish
      100.122.158.125 sawfish.ts
    '';
    networkmanager.enable = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
    fallbackDns = [
      "45.90.28.0#${hostname}-d76f76.dns.nextdns.io"
      "45.90.30.0#${hostname}-d76f76.dns.nextdns.io"
    ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
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

  users.users.mike = {
    isNormalUser = true;
    description = "Mike Georgeff";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nix.settings.trusted-users = [ "mike" ];

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
    system76.enableAll = true;
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

  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.05";
}
