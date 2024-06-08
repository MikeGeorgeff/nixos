{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    git-lfs
    git-crypt
    doppler
    wget
  ];
}
