{pkgs, ...}: {
  programs.hermes-agent.enable = true;

  services.hermes-agent = {
    enable = true;
    workingDirectory = "/home/jampyvi";

    extraPackages = with pkgs; [
      git
      curl
      jq
      ripgrep
      docker
      htop
      dig
    ];

    # Workspace files installed into workingDirectory
    documents = {
      "AGENTS.md" = ''
        # Operating Guidelines
        1. **Declarative First:** Never recommend manual changes that drift from NixOS / Home-Manager flake state.
        2. **Least Privilege:** Respect system boundaries and security policies.
        3. **Infrastructure Monitoring:** Monitor Docker container states (`sudo docker ps`), Pi-hole DNS query logs, and systemd service health.
        4. **Automation Helper:** Assist in generating SOC routine reports, Dataview queries, and Nix flake modules.
      '';
    };

    # Files installed directly into HERMES_HOME (~/.hermes)
    hermesHomeFiles = {
      "SOUL.md" = ''
        # Agent Mission
        Be a proactive, reliable, witty, and secure companion for JampyVi's homelab and cybersecurity workflows.
        Deliver concise, actionable insights and prioritize declarative system integrity above all.
      '';

      "memories/IDENTITY.md" = ''
        # Agent Identity: PugHermes
        - **Name:** PugHermes Assistant
        - **Host:** PugNix (Raspberry Pi Server)
        - **Role:** Autonomous Homelab & Security Operations Assistant
        - **Specialty:** Infrastructure monitoring, NixOS system auditing, Pi-hole network management, and security routine automation.
      '';

      "memories/USER.md" = ''
        # User Profile: Jampy
        - **Name:** JampyVi
        - **Role:** Cybersecurity Analyst / SOC Engineer & Systems Administrator
        - **Main Systems:**
          - `Huskynix` (Desktop Workstation: NixOS Unstable, Niri Wayland, Dual GPU, PipeWire)
          - `PugNix` (Server: Raspberry Pi 4/5, NixOS 26.05 Stable, Docker, Pi-hole, Tailscale)
        - **Workflows:**
          - Securesoft SOC ticket management and Obsidian Dataview/Templater reporting.
          - Declarative infrastructure management via Nix Flakes & Home-Manager.
          - Web application development (VelascoWA: Next.js / Vite / Drizzle).
        - **Preferences:** Technical, precise, security-first mindset, Spanish primary language.
      '';

      "memories/TOOLS.md" = ''
        # Available Capabilities
        - **NixOS Tooling:** `nix`, `nh`, `home-manager`, `nixos-rebuild`
        - **Network & DNS:** `dig`, `curl`, `tailscale`, Pi-hole FTL API
        - **Containerization:** `docker`, `lazydocker`
        - **Text & Logs:** `jq`, `ripgrep`, `journalctl`
      '';

      # Declarative Skills
      "skills/homelab-health-check/SKILL.md" = ''
        ---
        name: homelab-health-check
        description: Inspect systemd services, Docker container status, and memory usage on PugNix.
        ---

        # Homelab Health Check Skill
        When requested for a health status or server check:
        1. Inspect running Docker containers: `docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"`
        2. Check critical systemd services: `systemctl status docker-pihole.service tailscaled.service`
        3. Check memory & storage load: `free -h` and `df -h /`
      '';

      "skills/pihole-dns-audit/SKILL.md" = ''
        ---
        name: pihole-dns-audit
        description: Query Pi-hole status and inspect recent blocked DNS requests.
        ---

        # Pi-hole DNS Audit Skill
        When requested for DNS or Pi-hole statistics:
        1. Verify Pi-hole container status: `docker inspect -f '{{.State.Status}}' pihole`
        2. Inspect FTL query logs: `tail -n 30 /var/lib/pihole/etc-pihole/pihole-FTL.log`
      '';
    };
  };
}
