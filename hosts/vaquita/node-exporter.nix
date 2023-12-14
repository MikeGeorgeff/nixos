{ config, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    port = 9999;
    enabledCollectors = [
      "systemd"
      "processes"
    ];
  };
}
