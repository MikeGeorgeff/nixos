{ config, ... }:
{
    users.users.admin = {
        isNormalUser = true;
        description = "Admin";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [ 
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDV45PI7XVEWchRHVzuzoHD55SpdY+B3s82SXH6l+Cd mike@georgeff.co"
        ];
    };
    
    nix.settings.trusted-users = [ "admin" ];
}