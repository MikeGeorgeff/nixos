{ pkgs, ... }:
{
  programs.zsh.enable = true;

  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUvHCGg3xcWwL1IwQv6f88Nsi5PsMRTblm+jk+gscJ3 admin@condor"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINajRNfvaNvQxCOE1ikJbMTiEfCYVYRfA3U+u6kpQREZ admin@gharial"
    ];
  };

  nix.settings.trusted-users = [ "admin" ];
}
