# wallpaper-engine-plasma

A small helper for running [linux-wallpaperengine](https://github.com/Almamu/linux-wallpaperengine)
as your animated desktop background on **KDE Plasma (Wayland)**, with a simple `wallpaper` command
to switch between your Steam Workshop wallpapers, with image previews right in the terminal.

Run `wallpaper` to get a searchable list with a live preview of each wallpaper; press Enter to apply it.
Or use it from scripts:

```console
$ wallpaper list
1102620285   scene  Kyogre (Pokemon)
2225690388   video  Connector Yumi - Dream ver
3244466773   scene  Gengar | Full HD (1920x1080)
...
$ wallpaper 3244466773
Wallpaper set to 3244466773
```

## Why Plasma?

On Wayland, linux-wallpaperengine draws the background through the `wlr-layer-shell` protocol.
**GNOME does not support it**, so `--screen-root` fails there with `Failed to bind to required interfaces`,
and recent GNOME releases (e.g. Ubuntu 26.04 / GNOME 50) no longer ship an X11 session to fall back to.
KDE Plasma supports `wlr-layer-shell`, so the wallpaper works out of the box.

## Requirements

- KDE Plasma on Wayland (`sudo apt install kde-plasma-desktop` on Ubuntu)
- [linux-wallpaperengine](https://github.com/Almamu/linux-wallpaperengine) built from source
- Wallpaper Engine owned and installed through Steam, with some Workshop wallpapers subscribed
- `python3` and `kscreen-doctor` (part of Plasma)
- Optional, for previews: `fzf` and `chafa` (`sudo apt install fzf chafa`)

## Install

```bash
git clone https://github.com/feliksKdm/wallpaper-engine-plasma.git
cd wallpaper-engine-plasma
./install.sh --bin ~/path/to/linux-wallpaperengine/build/output/linux-wallpaperengine
```

Add `--set-plasma-default` to also make Plasma the default session on the login screen.

The installer:

- copies `wallpaper` to `~/.local/bin`
- writes a config to `~/.config/wallpaper-engine-plasma/config`
- adds an autostart entry (Plasma only) that restores your last wallpaper on login

## Usage

| Command | What it does |
|---|---|
| `wallpaper` | Interactive picker with previews (falls back to `list` without `fzf`/`chafa`) |
| `wallpaper list` | List installed wallpapers (ID, type, title) |
| `wallpaper <id>` | Switch to wallpaper `<id>`, remembered for the next login |
| `wallpaper preview <id>` | Show the preview image of wallpaper `<id>` |
| `wallpaper current` | Show the current wallpaper ID |
| `wallpaper stop` | Stop the animated wallpaper |
| `wallpaper restore` | Start the remembered wallpaper (used by autostart) |

New wallpapers appear in the list as soon as you subscribe to them in the Steam Workshop
and Steam finishes downloading them. `scene` and `video` wallpapers work best; `web` ones may not render correctly.

## Configuration

Edit `~/.config/wallpaper-engine-plasma/config`:

| Option | Default | Description |
|---|---|---|
| `WPE_BIN` | set by installer | Path to the `linux-wallpaperengine` binary |
| `SCREENS` | all enabled screens | Screens to draw on, e.g. `"eDP-1 HDMI-A-1"` |
| `WORKSHOP_DIRS` | auto-detected | Workshop folders (`.../workshop/content/431960`), `:`-separated |
| `SCALING` | `fill` | `fill` covers the screen (crops the edges); `fit` shows the whole image, which can leave smeared bars |
| `MOUSE` | `off` | `on` lets wallpapers react to the mouse, but they then capture the cursor and desktop clicks |
| `LAYER` | `bottom` | Wayland layer for the wallpaper: `bottom` or `background` |
| `EXTRA_ARGS` | empty | Extra flags, e.g. `"--fps 24 --silent"` to save battery |
| `PREVIEW_FORMAT` | guessed | Image protocol for previews: `sixels`, `kitty`, `iterm` or `symbols` |

Native, Snap and Flatpak Steam installs (and extra Steam library folders) are detected automatically.

Previews use real images in Konsole, kitty, WezTerm, foot and Ghostty. In other terminals they fall back
to colored text blocks; set `PREVIEW_FORMAT` if your terminal supports sixels or the kitty protocol.

## Uninstall

```bash
./uninstall.sh
```

This removes the command, its config and the autostart entry. linux-wallpaperengine and your login session are left untouched.

---

## Кратко по-русски

Скрипт для анимированных обоев Wallpaper Engine в KDE Plasma (Wayland). В GNOME это не работает: там нет протокола `wlr-layer-shell`.

```bash
./install.sh --bin ~/путь/к/linux-wallpaperengine/build/output/linux-wallpaperengine
sudo apt install fzf chafa   # для превью картинок в терминале
wallpaper              # выбрать обои с превью (Enter — поставить)
wallpaper list         # просто список
wallpaper <id>         # поставить обои
wallpaper stop         # выключить
```

## License

MIT, see [LICENSE](LICENSE). linux-wallpaperengine itself is a separate project under GPL-3.0.
