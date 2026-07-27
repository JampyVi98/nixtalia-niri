#!/usr/bin/env bash
set -euo pipefail

log() { printf "%b\n" "$1"; }
warn() { printf "\033[1;33m%b\033[0m\n" "$1"; }

TARGET_DIR="$HOME/.local/lib/millennium"
mkdir -p "$TARGET_DIR"

log "Fetching latest Millennium release info..."
LATEST_RELEASE=$(curl -fsSL https://api.github.com/repos/SteamClientHomebrew/Millennium/releases/latest)
TAG=$(echo "$LATEST_RELEASE" | python3 -c "import sys, json; print(json.load(sys.stdin)['tag_name'])")
log "Latest version is $TAG"

DOWNLOAD_URL="https://github.com/SteamClientHomebrew/Millennium/releases/download/$TAG/millennium-v${TAG#v}-linux-x86_64.tar.gz"
TEMP_TAR=$(mktemp)

log "Downloading Millennium..."
curl -fsSL -o "$TEMP_TAR" "$DOWNLOAD_URL"

log "Extracting to $TARGET_DIR..."
tar -xzf "$TEMP_TAR" -C "$TARGET_DIR"
rm -f "$TEMP_TAR"

log "Creating symlinks in Steam directory..."
STEAM_DIR="$HOME/.steam/steam"
mkdir -p "$STEAM_DIR/ubuntu12_32" "$STEAM_DIR/ubuntu12_64"

ln -sf "$TARGET_DIR/usr/lib/millennium/libmillennium_bootstrap_x86.so"   "$STEAM_DIR/ubuntu12_32/libXtst.so.6"
ln -sf "$TARGET_DIR/usr/lib/millennium/libmillennium_bootstrap_hhx64.so" "$STEAM_DIR/ubuntu12_64/libXtst.so.6"
ln -sf "$TARGET_DIR/usr/lib/millennium/libmillennium_hhx64.so"           "$STEAM_DIR/ubuntu12_64/libmillennium_hhx64.so"

# Make libraries executable
chmod +x "$TARGET_DIR"/usr/lib/millennium/libmillennium_* 2>/dev/null || true

log "Millennium successfully installed in user-space!"
log "Please restart Steam and configure the Matugen theme to sync with Noctalia."
