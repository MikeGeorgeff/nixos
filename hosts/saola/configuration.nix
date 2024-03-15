{ config, pkgs, ... }:
let
  hostname = "saola";
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/locale.nix
    ../modules/openssh.nix
    ../modules/nameservers-default.nix
    ../modules/tailscale.nix
    ../modules/user-deploy.nix
    ./nfs-mounts.nix
    ./services/docker.nix
    ./nginx.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.etc."nix-cache-key" = {
    enable = true;
    source = ../../secrets/nix-cache-key.sec;
    target = "nix-cache-key.sec";
  };

  nix.extraOptions = ''
    secret-key-files = /etc/nix-cache-key.sec
  '';

  nix.sshServe = {
    enable = true;
    protocol = "ssh-ng";
    write = true;
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHDEzNa2qKsEGY/r0TRyCbwET19eC9lVSnCTEzIEk4j admin@pangolin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC3pcSalbsAdhaz7tjtFVE7sVbFEafyhvkNsSyb1pY7c woodpecker"
    ];
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nix-cache-key.sec";
  };

  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUvHCGg3xcWwL1IwQv6f88Nsi5PsMRTblm+jk+gscJ3 admin@condor"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHDEzNa2qKsEGY/r0TRyCbwET19eC9lVSnCTEzIEk4j admin@pangolin"
    ];
  };

  programs.zsh.enable = true;

  nix.settings.trusted-users = [ "admin" ];

  networking = {
    hostName = "${hostname}";
    firewall.allowedTCPPorts = [ 22 8080 ];
    extraHosts = ''
      100.97.94.63  pangolin
      100.88.169.90 condor
      10.10.3.1     vaquita
      10.10.3.2     saola
      10.10.3.3     addax
    '';
    defaultGateway.address = "10.10.3.1";
    interfaces.enp5s0 = {
      useDHCP = false;
      wakeOnLan.enable = true;
      ipv4.addresses = [{
        address = "10.10.3.2";
        prefixLength = 24;
      }];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    git-crypt
    parted
    wget
  ];

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.2"
  ];

  system.stateVersion = "23.11";
}
