{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fw-ectool
  ];
}
