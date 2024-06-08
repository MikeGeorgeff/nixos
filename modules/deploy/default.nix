{ ... }:
{
  users.users.deploy = {
    isNormalUser = true;
    description = "Deploy";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmMdJ4rd9NeA2UApY08gkPPML7SBON41QzLkmFYDH89 admin@saola"
    ];
  };

  nix.settings.trusted-users = [ "deploy" ];
}
