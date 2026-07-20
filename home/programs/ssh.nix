{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        # forwardAgent = false;
        # addKeysToAgent = "yes";
        # compression = false;
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        # serverAliveInterval = 0;
        # serverAliveCountMax = 3;
        hostname = "ssh.github.com";
        port = 443;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        user = "git";
      };
    };
  };

  services.ssh-agent = {
    enable = true;
  };
}
