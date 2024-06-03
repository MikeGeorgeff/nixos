{ config, ... }:
{
  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmMdJ4rd9NeA2UApY08gkPPML7SBON41QzLkmFYDH89 admin@saola"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINajRNfvaNvQxCOE1ikJbMTiEfCYVYRfA3U+u6kpQREZ admin@gharial"
    ];
  };

  nix.settings.trusted-users = [ "admin" ];
}
