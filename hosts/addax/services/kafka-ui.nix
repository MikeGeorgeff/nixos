{ config, pkgs, ... }:
let
  domain = "kafka-ui.georgeff.co";
  port = "8080";
  secrets = import ../../../secrets/kafka.nix;
in
{
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
      KAFKA_CLUSTERS_1_NAME = "${secrets.staging.name}";
      KAFKA_CLUSTERS_1_READONLY = "true";
      KAFKA_CLUSTERS_1_BOOTSTRAPSERVERS = "${secrets.staging.server}";
      KAFKA_CLUSTERS_1_PROPERTIES_SECURITY_PROTOCOL = "SASL_SSL";
      KAFKA_CLUSTERS_1_PROPERTIES_SASL_MECHANISM = "SCRAM-SHA-256";
      KAFKA_CLUSTERS_1_PROPERTIES_SASL_JAAS_CONFIG = "org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${secrets.staging.username}\" password=\"${secrets.staging.password}\";";
      KAFKA_CLUSTERS_2_NAME = "${secrets.dev.name}";
      KAFKA_CLUSTERS_2_READONLY = "true";
      KAFKA_CLUSTERS_2_BOOTSTRAPSERVERS = "${secrets.dev.server}";
      KAFKA_CLUSTERS_2_PROPERTIES_SECURITY_PROTOCOL = "SASL_SSL";
      KAFKA_CLUSTERS_2_PROPERTIES_SASL_MECHANISM = "SCRAM-SHA-256";
      KAFKA_CLUSTERS_2_PROPERTIES_SASL_JAAS_CONFIG = "org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${secrets.dev.username}\" password=\"${secrets.dev.password}\";";
    };
    ports = [
      "${port}:8080"
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
