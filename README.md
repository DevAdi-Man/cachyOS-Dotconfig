# CachyOS Dotconfig

Snapshot of the current CachyOS Hyprland setup, with the integrated Quickshell V1/V2 bar and lock screen, Neovim configuration and lazy.nvim lockfile, Recursive font, Bash Oh My Posh prompt, and the current `mono` wallpaper and palette. The source system uses Hyprland 0.57.2, Quickshell 0.3.2, and Neovim 0.12.6.

## Install on CachyOS

Run from this checkout as your desktop user. The desktop scripts use `~/.config`.

```bash
./install.sh --dry-run --install-pkgs
./install.sh --install-pkgs
```

The package step runs a normal CachyOS upgrade and installs the desktop and Neovim dependencies. It uses `paru` or `yay` for AUR packages and installs `paru` from CachyOS repos when neither helper is available. Package failures stop the install before config files are copied. [Arch system maintenance](https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported)

Run `./install.sh` for config-only installation, or add `-y` to skip the confirmation. Backups are created under `~/.config_backup_*` on the first replacement and retain the original paths relative to your home. Use `--backup-dir DIR` to pick a new backup directory or `--no-backup` to skip backups. A repeated install keeps matching files in place.

After installation, start a new Hyprland session. Open `nvim` with network access for the initial plugin and language-tool downloads. The installer ships TPM and installs its bundled plugins when they are missing. Hyprland includes a fallback monitor rule, with the source machine’s eDP and HDMI settings in `hypr/lua/display.lua`.

## Machine-specific components

- SDDM configuration samples in `sddm/` reflect the current Astronaut/Ulquiorra setup. Apply them separately if the destination uses SDDM and has the theme installed. Set `ConfigFile=Themes/ulquiorra_theme.conf` in the theme’s `metadata.desktop`. [Astronaut theme installation](https://github.com/Keyitdev/sddm-astronaut-theme#manual-installation)
- The dedicated Quickshell updater timer is enabled when the separate deploy clone exists at `~/.local/share/quickshell-dots`. The bar and lock screen are already included in this checkout.
- The live bindings for Gyotaku and TwinDesk use their separately installed applications. The OBS scene can refer to devices and sources that need to be reselected on another machine.

## ⌨️ Keybindings Quick Reference

### Application Shortcuts

| Keybinding | Action |
| :--- | :--- |
| `Super + Return` / `Super + T` | Open Kitty terminal |
| `Super + M` | Open Rofi application launcher |
| `Super + Space` | Open Gyotaku screenshot search if installed |
| `Super + B` | Open web browser |
| `Super + E` | Open Thunar file manager |
| `Super + V` | Toggle CopyQ clipboard history |
| `Super + L` | Lock screen with Quickshell |
| `Super + Escape` | Open Wlogout power menu |
| `Super + I` | Open NetworkManager Wi-Fi selector |
| `Super + F1` | **Switch to a random wallpaper & regenerate theme colors** |

### Window Management

| Keybinding | Action |
| :--- | :--- |
| `Super + Q` | Close active window |
| `Super + F` | Toggle maximized / fullscreen window |
| `Super + D` | Toggle floating state |
| `Alt + /` | Toggle horizontal/vertical split orientation |
| `Super + H/J/K/L` or `Arrows` | Move focus between windows |
| `Super + Shift + H/J/K/L` | Move active window |
| `Super + Ctrl + H/J/K/L` | Resize active window |
| `Super + 1` .. `0` | Switch to workspace 1–10 |
| `Super + Shift + 1` .. `0` | Move window to workspace 1–10 |
| `Super + S` | Toggle special scratchpad workspace |

### Audio, Media & Brightness

| Keybinding | Action |
| :--- | :--- |
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume -5% (with safety minimum) |
| `XF86AudioMute` | Toggle speaker mute |
| `XF86AudioMicMute` / `Ctrl + M` | Toggle microphone mute |
| `XF86MonBrightnessUp` | Screen brightness +5% |
| `XF86MonBrightnessDown` | Screen brightness -5% |
| `Media Keys` / `Alt + F1..F3` | Media Previous / Play-Pause / Next |

### Screenshots & Recording

| Keybinding | Action |
| :--- | :--- |
| `Super + P` | Select region → Annotate & save with Swappy |
| `Super + Alt + P` | Fullscreen capture → Swappy |
| `Super + Shift + P` | Active window capture → Swappy |
| `Super + Ctrl + P` | Region select → Direct copy to system clipboard |
| `Super + F9` | Region screen recording (`wf-recorder`) |
| `Super + F10` | Fullscreen recording (`wf-recorder`) |

---

## 🎨 Wallpaper & Theming Engine

The theming system is completely automated and wallpaper-driven:
1. When you select a wallpaper (or press `Super + F1`), `omarchy-theme-bg-set` sets the wallpaper with `swaybg`.
2. `qs-theme-bridge` runs `matugen` to extract the dominant color palette from the image.
3. The extracted palette is written to `~/.config/omarchy/current/theme/colors.toml`.
4. Theme change hooks trigger a live reload of the Quickshell bar and terminal themes without restarting the session.

To manually set any wallpaper as the active theme:
```bash
omarchy-theme-bg-set ~/Pictures/wallpapers/<wallpaper-name>.jpg
```

Or switch themes by name:
```bash
omarchy-theme-set mono
```
