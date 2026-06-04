{...}: {
  services.borgbackup.jobs.erebos-home = {
    paths = "/home/jampyvi";
    exclude = [
      "/home/jampyvi/.cache"
      "/home/jampyvi/.nix-defexpr"
      "/home/jampyvi/.nix-profile"
      "/home/jampyvi/.mozilla"
      "/home/jampyvi/.pki"
      "/home/jampyvi/.steam"
      "/home/jampyvi/.terraform.d"
      "/home/jampyvi/.var"
    ];
    encryption.mode = "repokey";
    encryption.passCommand = "cat /run/agenix/borg.erebos.age";
    environment.BORG_RSH = "ssh -i /home/jampyvi/.ssh/borg";
    repo = "ssh://borg@100.106.154.7:22/mnt/backups/erebos_new";
    compression = "auto,zstd";
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 3;
    };
    startAt = [];
  };

  age.secrets."borg.erebos.age" = {
    file = ../../../secrets/borg.erebos.age;
    path = "/run/agenix/borg.erebos.age";
    owner = "jampyvi";
    group = "users";
    mode = "0400";
  };
}
