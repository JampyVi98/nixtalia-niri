{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.server.services.pihole;
in {
  options.server.services.pihole = {
    enable = lib.mkEnableOption "Pi-hole DNS server via Docker container";

    port = lib.mkOption {
      type = lib.types.port;
      default = 80;
      description = "HTTP Port for Pi-hole web dashboard";
    };

    password = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Initial admin password for web dashboard (optional)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable system docker daemon
    virtualisation.docker.enable = true;

    # Disable systemd-resolved DNS stub listener to free port 53 for Pi-hole
    services.resolved.settings = {
      Resolve = {
        DNSStubListener = "no";
      };
    };

    # Open firewall ports for DNS (53) and Web UI (default 80)
    networking.firewall = {
      allowedTCPPorts = [ 53 cfg.port ];
      allowedUDPPorts = [ 53 67 ];
    };

    # Declarative OCI container definition for Pi-hole
    virtualisation.oci-containers = {
      backend = "docker";
      containers.pihole = {
        image = "pihole/pihole:latest";
        autoStart = true;
        ports = [
          "53:53/tcp"
          "53:53/udp"
          "${toString cfg.port}:80/tcp"
        ];
        environment = {
          TZ = config.time.timeZone;
          DNSMASQ_LISTENING = "all";
          FTLCONF_dns_listeningMode = "all";
        } // (lib.optionalAttrs (cfg.password != null) {
          WEBPASSWORD = cfg.password;
        });
        volumes = [
          "/var/lib/pihole/etc-pihole:/etc/pihole"
          "/var/lib/pihole/etc-dnsmasq.d:/etc/dnsmasq.d"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
        ];
      };
    };
  };
}
