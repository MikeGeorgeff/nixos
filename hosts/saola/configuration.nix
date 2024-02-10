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
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDV45PI7XVEWchRHVzuzoHD55SpdY+B3s82SXH6l+Cd mike@georgeff.co"
    ];
  };

  programs.zsh.enable = true;

  nix.settings.trusted-users = [ "admin" ];

  networking = {
    hostName = "${hostname}";
    firewall.allowedTCPPorts = [ 22 8080 ];
    extraHosts = ''
        100.72.135.69 pangolin
        10.10.3.1     vaquita
        10.10.3.2     saola
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
