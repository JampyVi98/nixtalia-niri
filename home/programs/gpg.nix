{
  config,
  pkgs,
  ...
}: {
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    settings = {
      # El default-key es el ID hexadecimal corto/largo de tu llave pública/privada de GPG.
      # Git y GnuPG usan este ID para saber qué llave usar para firmar tus commits y archivos.
      # Puedes ver tus llaves ejecutando: gpg --list-secret-keys --keyid-format=long
      default-key = "EE6866A76C287DE4";
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
