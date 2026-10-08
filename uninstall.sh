#!/usr/bin/env bash
# Removes the `wallpaper` command, its autostart entry and its config.

set -u

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wallpaper-engine-plasma"
AUTOSTART_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"

pkill -x linux-wallpaper 2>/dev/null
rm -f "$HOME/.local/bin/wallpaper" "$AUTOSTART_DIR/wallpaper-engine-plasma.desktop"
rm -rf "$CONFIG_DIR"

echo "Uninstalled. linux-wallpaperengine itself and your login session were left untouched."
