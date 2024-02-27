{ config, pkgs, ... }:
let
  stateDir = "/mnt/vault/services/kafka-ui";
  domain = "kafka-ui.georgeff.co";
  port = "8080";
  secrets = import ../../../secrets/kafka.nix;
in
{
  systemd.tmpfiles.rules = [
    "d ${stateDir} 0770 admin users -"
  ];

  virtualisation.oci-containers.containers."kafka-ui" = {
    image = "provectuslabs/kafka-ui:latest";
    autoStart = true;
    environment = {
      AUTH_TYPE = "LOGIN_FORM";
      SPRING_SECURITY_USER_NAME = "${secrets.ui.auth.basic.username}";
      SPRING_SECURITY_USER_PASSWORD = "${secrets.ui.auth.basic.password}";
      KAFKA_CLUSTERS_0_NAME = "${secrets.production.name}";
      KAFKA_CLUSTERS_0_READONLY = "true";
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS = "${secrets.production.server}";
      KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL = "SASL_SSL";
      KAFKA_CLUSTERS_0_PROPERTIES_SASL_MECHANISM = "SCRAM-SHA-256";
      KAFKA_CLUSTERS_0_PROPERTIES_SASL_JAAS_CONFIG = "org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${secrets.production.username}\" password=\"${secrets.production.password}\";";
    };
    ports = [
      "${port}:8080"
    ];
    volumes = [
      "${stateDir}/config.yml:/etc/kafkaui/dynamic_config.yaml"
    ];
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "georgeff.co";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };
}
