{ pkgs, config, ... }:
let
  server = "10.10.3.3:9000";
  secrets = import ../../../secrets/woodpecker.nix;
in
{
  services.woodpecker-agents.agents = {
    blackhawk = {
      enable = true;

      environment = {
        WOODPECKER_BACKEND = "local";
        WOODPECKER_SERVER = "${server}";
        WOODPECKER_MAX_WORKFLOWS = "5";
        WOODPECKER_AGENT_SECRET = "${secrets.agent.secret}";
      };

      path = with pkgs; [
        git
        git-lfs
        woodpecker-plugin-git
        bash
        coreutils
      ];
    };

  };
}
