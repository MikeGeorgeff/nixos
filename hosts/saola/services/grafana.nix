{ config, ... }:
{
  # Loki port
  networking.firewall.allowedTCPPorts = [ 9001 ];

  services.postgresql = {
    ensureDatabases = [ "grafana" ];

    ensureUsers = [{
      name = "grafana";
      ensureDBOwnership = true;
    }];
  };

  services.grafana = {
    enable = true;

    settings = {
      server = {
        root_url = "https://grafana.georgeff.co";
        http_addr = "127.0.0.1";
        http_port = 8000;
      };

      database = {
        type = "postgres";
        host = "/var/run/postgresql";
        user = "grafana";
        name = "grafana";
      };
    };

    provision = {
      enable = true;

      datasources = {
        settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            }
            {
              name = "Loki";
              type = "loki";
              url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
            }
          ];
        };
      };
    };
  };

  services.prometheus = {
    enable = true;
    port = 9000;

    scrapeConfigs = [
      {
        job_name = "saola";
        static_configs = [{
          targets = [ "127.0.0.1:9999" ];
        }];
      }
      {
        job_name = "vaquita";
        static_configs = [{
          targets = [ "10.10.3.1:9999" ];
        }];
      }
    ];

    exporters = {
      node = {
        enable = true;
        port = 9999;
        enabledCollectors = [
          "systemd"
          "processes"
        ];
      };
    };
  };

  services.loki = {
    enable = true;

    configuration = {
      server.http_listen_port = 9001;
      auth_enabled = false;

      common = {
        instance_addr = "127.0.0.1";
        path_prefix = "${config.services.loki.dataDir}";

        storage.filesystem = {
          chunks_directory = "${config.services.loki.dataDir}/chunks";
          rules_directory = "${config.services.loki.dataDir}/rules";
        };

        replication_factor = 1;
        ring.kvstore.store = "inmemory";
      };

      query_range = {
        results_cache = {
          cache = {
            embedded_cache = {
              enabled = true;
              max_size_mb = 100;
            };
          };
        };
      };

      schema_config.configs = [{
        from = "2023-12-07";
        store = "tsdb";
        object_store = "filesystem";
        schema = "v12";
        index = {
          prefix = "index_";
          period = "24h";
        };
      }];
    };
  };

  services.promtail = {
    enable = true;

    configuration = {
      server = {
        http_listen_port = 9998;
        grpc_listen_port = 0;
      };

      clients = [{
        url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
      }];

      scrape_configs = [
        {
          job_name = "journal";

          journal = {
            max_age = "12h";

            labels = {
              job = "systemd-journal";
              host = "saola";
            };
          };

          relabel_configs = [{
            source_labels = [ "__journal__systemd_unit" ];
            target_label = "unit";
          }];
        }
      ];
    };
  };
}
