{ ... }:
{
  nix.settings = {
    trusted-substituters = [ "ssh-ng://nix-ssh@saola.georgeff.co" ];
    trusted-public-keys = [
      "saola.georgeff.co-1:KKcFKKIJSIXUgaLrhKhZqHwVm/qVb2iRKVVNj8d+Ivw="
    ];
  };
}
