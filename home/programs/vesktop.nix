{
  lib,
  pkgs,
  ...
}: {
  # Declaratively bootstrap / update Vesktop settings to ensure FakeNitro is enabled
  # while keeping the file writeable so the client can save settings at runtime.
  home.activation.ensureVesktopConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.config/vesktop
    if [ ! -f $HOME/.config/vesktop/settings.json ]; then
      echo '{"discordBranch":"stable","firstLaunch":false,"plugins":{"FakeNitro":{"enabled":true}}}' > $HOME/.config/vesktop/settings.json
    else
      # Update settings.json in-place using python to preserve existing settings
      ${pkgs.python3}/bin/python3 -c '
import json, os
path = os.path.expanduser("~/.config/vesktop/settings.json")
try:
    with open(path, "r") as f:
        data = json.load(f)
except Exception:
    data = {}
if "plugins" not in data:
    data["plugins"] = {}
if "FakeNitro" not in data:
    data["plugins"]["FakeNitro"] = {}
data["plugins"]["FakeNitro"]["enabled"] = True
with open(path, "w") as f:
    json.dump(data, f, indent=2)
'
    fi
  '';
}
