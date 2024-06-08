{ ... }:
{
  services.libinput = {
    enable = true;

    touchpad = {
      tapping = false;
      disableWhileTyping = true;
      clickMethod = "clickfinger";
    };
  };
}
