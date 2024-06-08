{ pkgs, ... }:
{
  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
  };

  nix.settings.trusted-users = [ "admin" ];
}
