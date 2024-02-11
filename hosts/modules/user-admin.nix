{ config, ... }:
{
  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHDEzNa2qKsEGY/r0TRyCbwET19eC9lVSnCTEzIEk4j admin@pangolin"
    ];
  };

  nix.settings.trusted-users = [ "admin" ];
}
