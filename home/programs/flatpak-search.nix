{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "ftv" ''
      # Check if an argument is provided
      if [ -z "$1" ]; then
          echo "Usage: flatpak-search-tv <search_term>"
          exit 1
      fi

      # Perform search and pipe to fzf. We request columns: application, name, description.
      selected=$(flatpak search --columns=application,name,description "$1" | ${pkgs.fzf}/bin/fzf --prompt="Select Flatpak: " --height=40% --reverse)

      if [ -n "$selected" ]; then
          # The first column is the Application ID
          app_id=$(echo "$selected" | awk '{print $1}')

          # Format for declarative-flatpak
          formatted="\"flathub:app/''${app_id}//stable\""

          echo -e "\n\e[34mInstalando \e[1m$app_id\e[0m\e[34m para uso inmediato...\e[0m"
          flatpak install -y flathub "''${app_id}"

          # Copy to clipboard
          echo -n "$formatted" | ${pkgs.wl-clipboard}/bin/wl-copy

          echo -e "\n\e[32m✔ ¡Instalado!\e[0m"
          echo -e "\e[33m[!] ATENCIÓN:\e[0m Para que esta app sobreviva a un formateo futuro, pégala en tu config de Nix."
          echo -e "Ya he copiado el texto al portapapeles: \e[1m$formatted\e[0m"
          echo "Pégalo en: devices/desktop/huskynix/default.nix bajo workstation.flatpak.packages"
      else
          echo "Canceled."
      fi
    '')
  ];
}
