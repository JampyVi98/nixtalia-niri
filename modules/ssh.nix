{
  config,
  lib,
  ...
}: let
  cfg = config.workstation.ssh;
in {
  options.workstation.ssh.enable = lib.mkEnableOption "Default SSH configuration";
  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = ["jampyvi"];
      };
    };
    users.users."jampyvi".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEH4xfKvUQry7F+0Im9dW9RLb9moZzxtZZajBcWwZq0M jampyvi"
    ];
    networking.firewall.allowedTCPPorts = [22];
  };
}
