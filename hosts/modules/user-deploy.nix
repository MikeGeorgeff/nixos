{ config, ... }:
{
    users.users.deploy = {
        isNormalUser = true;
        description = "Deploy";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlHEVQHOoM/VqjAZHNlnuIcjeNVBdB/12i9iZVT9adH admin@saola"
        ];
    };

    nix.settings.trusted-users = [ "deploy" ];
}