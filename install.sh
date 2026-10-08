#!/usr/bin/env bash
# Installs the `wallpaper` command, writes its config and sets up autostart on KDE Plasma.
#
#   ./install.sh [--bin /path/to/linux-wallpaperengine] [--set-plasma-default]
#
#   --bin                 path to the linux-wallpaperengine binary (auto-detected otherwise)
#   --set-plasma-default  make Plasma the default session on the login screen

set -eu

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wallpaper-engine-plasma"
AUTOSTART_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"

wpe_bin=""
set_default=0

while [ $# -gt 0 ]; do
    case "$1" in
        --bin) wpe_bin="$2"; shift 2 ;;
        --set-plasma-default) set_default=1; shift ;;
        -h|--help) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

# Find linux-wallpaperengine: argument, PATH, then common build locations
if [ -z "$wpe_bin" ]; then
    if command -v linux-wallpaperengine >/dev/null 2>&1; then
        wpe_bin="$(command -v linux-wallpaperengine)"
    else
        wpe_bin="$(find "$HOME" -maxdepth 6 -type f -name linux-wallpaperengine -path '*/output/*' -perm -u+x 2>/dev/null | head -n 1)"
    fi
fi
if [ -z "$wpe_bin" ] || [ ! -x "$wpe_bin" ]; then
    echo "linux-wallpaperengine was not found. Build it first, then run:" >&2
    echo "  ./install.sh --bin /path/to/build/output/linux-wallpaperengine" >&2
    exit 1
fi
wpe_bin="$(realpath "$wpe_bin")"
echo "Using linux-wallpaperengine at $wpe_bin"

install -Dm755 "$SRC_DIR/bin/wallpaper" "$BIN_DIR/wallpaper"
echo "Installed $BIN_DIR/wallpaper"

mkdir -p "$CONFIG_DIR"
if [ ! -f "$CONFIG_DIR/config" ]; then
    sed "s|^WPE_BIN=.*|WPE_BIN=\"$wpe_bin\"|" "$SRC_DIR/config.example" > "$CONFIG_DIR/config"
    echo "Wrote $CONFIG_DIR/config"
else
    echo "Kept existing $CONFIG_DIR/config"
fi

install -Dm644 "$SRC_DIR/autostart/wallpaper-engine-plasma.desktop" "$AUTOSTART_DIR/wallpaper-engine-plasma.desktop"
sed -i "s|^Exec=.*|Exec=$BIN_DIR/wallpaper restore|" "$AUTOSTART_DIR/wallpaper-engine-plasma.desktop"
echo "Installed autostart entry"

if [ "$set_default" = 1 ]; then
    if [ -f /usr/share/wayland-sessions/plasma.desktop ]; then
        busctl call org.freedesktop.Accounts "/org/freedesktop/Accounts/User$(id -u)" \
            org.freedesktop.Accounts.User SetSession s plasma
        echo "Plasma is now the default session"
    else
        echo "Plasma session not found, install KDE Plasma first" >&2
    fi
fi

case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) echo "Note: $BIN_DIR is not in your PATH, add it to use the 'wallpaper' command" ;;
esac

echo "Done. Run 'wallpaper' to list your wallpapers and 'wallpaper <id>' to set one."
