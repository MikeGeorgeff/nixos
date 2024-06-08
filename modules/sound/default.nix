{ pkgs, ... }:
{
  sound.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
    pulseaudioFull
    pavucontrol
  ];
}
