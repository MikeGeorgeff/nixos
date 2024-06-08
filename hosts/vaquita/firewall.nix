{ ... }:
{
  networking.nftables = {
    enable = true;
    ruleset = ''
      table ip filter {

        chain output {
          type filter hook output priority 100; policy accept;
        }

        chain input {
          type filter hook input priority filter; policy drop;

          # Allow truested networks to access the router
          iifname { "enp2s0", "lan" } counter accept

          # Allow establised traffic from the wan
          iifname "enp6s0" ct state { established, related } counter accept
          iifname "enp6s0" counter drop
        }

        chain forward {
          type filter hook forward priority filter; policy drop;

          # Allow all networks access to the wan
          iifname { "enp1s0", "enp2s0", "lan", "iot", "guest", "gaming", "enp3s0" } oifname { "enp6s0" } counter accept
          iifname { "enp6s0" } oifname { "enp1s0", "enp2s0", "lan", "iot", "guest", "gaming", "enp3s0" } ct state established,related counter accept

          # Allow enp2s0 & lan to access enp1s0
          iifname { "enp2s0", "lan" } oifname { "enp1s0" } counter accept
          iifname { "enp1s0" } oifname { "enp2s0", "lan" } ct state established,related counter accept

          # Allow enp2s0, lan & tailsscale subnet router to access iot
          iifname { "enp2s0", "lan", "tailscale0" } oifname { "iot" } counter accept
          iifname { "iot" } oifname { "enp2s0", "lan", "tailscale0" } ct state established,related counter accept

          # Allow enp2s0 to access lan
          iifname { "enp2s0" } oifname { "lan" } counter accept
          iifname { "lan" } oifname { "enp2s0" } ct state established,related counter accept

          # Allow lan to access enp2s0
          iifname { "lan" } oifname { "enp2s0" } counter accept
          iifname { "enp2s0" } oifname { "lan" } ct state established,related counter accept
        }
      }

      table ip nat {
        chain prerouting {
          type nat hook prerouting priority filter; policy accept;
        }

        # Setup nat  masquerading on the enp6s0 interface
        chain postrouting {
          type nat hook postrouting priority filter; policy accept;
          oifname "enp6s0" masquerade
        }
      }

      # Drop all ipv6 traffic because it is not supported
      table ip6 filter {
        chain input {
          type filter hook input priority 0; policy drop;
        }

        chain forward {
          type filter hook forward priority 0; policy drop;
        }
      }
    '';
  };
}
