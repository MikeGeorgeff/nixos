{ ... }:
{
  environment.etc."nix-cache-key" = {
    enable = true;
    source = ../../secrets/nix-cache-key.sec;
    target = "nix-cache-key.sec";
  };

  nix.extraOptions = ''
    secret-key-files = /etc/nix-cache-key.sec
  '';

  nix.sshServe = {
    enable = true;
    protocol = "ssh-ng";
    write = true;
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINajRNfvaNvQxCOE1ikJbMTiEfCYVYRfA3U+u6kpQREZ admin@gharial"
    ];
  };
}
