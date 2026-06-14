{ pkgs, ... }: 
let
  noctalia-plugins = pkgs.fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia-plugins";
    rev = "main";
    sha256 = "0bilfww3sfbx8wjgg9fv2ch5innrhax0irxm7khg33cjlsvbzvw9";
  };
in {
  # Instalación declarativa de plugins de Noctalia
  home.file = {
    ".config/noctalia/plugins/translator".source = noctalia-plugins + "/translator";
    ".config/noctalia/plugins/privacy-indicator".source = noctalia-plugins + "/privacy-indicator";
    ".config/noctalia/plugins/noctalia-calculator".source = noctalia-plugins + "/noctalia-calculator";
    ".config/noctalia/plugins/tailscale".source = noctalia-plugins + "/tailscale";
    ".config/noctalia/plugins/clipboard".source = noctalia-plugins + "/clipboard";
  };
}
