{
  hostName,
  lib,
  ...
}: let
  niriConfig =
    if hostName == "prometheus"
    then ../../config/niri/config.laptop.kdl
    else ../../config/niri/config.desktop.kdl;
in {
  xdg.configFile = {
    "niri/config.kdl".source = niriConfig;
  };

  home.activation.ensureNoctaliaConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.config/niri
    if [ ! -f $HOME/.config/niri/noctalia.kdl ]; then
      touch $HOME/.config/niri/noctalia.kdl
    fi
  '';
}
