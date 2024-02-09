{ config, pkgs, ... }:
let
  ipAddress = "10.10.3.99";
  gateway = "10.10.3.1";
  interface = "enp4s0";

  users = import ../secrets/users.nix;
in
{
  imports = [
    ./configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = [ "wheel" ];
    hashedPassword = "${users.passwords.admin}";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDV45PI7XVEWchRHVzuzoHD55SpdY+B3s82SXH6l+Cd mike@georgeff.co"
    ];
  };

  users.users.deploy = {
    isNormalUser = true;
    description = "Deploy";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDV45PI7XVEWchRHVzuzoHD55SpdY+B3s82SXH6l+Cd mike@georgeff.co"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlHEVQHOoM/VqjAZHNlnuIcjeNVBdB/12i9iZVT9adH admin@saola"
    ];
  };

  nix.settings.trusted-users = [ "admin" "deploy" ];

  networking = {
    hostName = "nixos";
    firewall.allowedTCPPorts = [ 22 ];
    defaultGateway.address = "${gateway}";
    interfaces."${interface}" = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "${ipAddress}";
        prefixLength = 24;
      }];
    };
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
