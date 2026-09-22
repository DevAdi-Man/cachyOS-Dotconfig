# ❄️ Aesthetic Hyprland Rice & Dotfiles (`dotconfig`)

A modern, highly responsive, and dynamically themed Wayland desktop environment powered by **Hyprland**, **Quickshell**, **Waybar**, **Omarchy**, and **Matugen**.

![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-58E1E1?style=for-the-badge&logo=hyprland&logoColor=black)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Quickshell](https://img.shields.io/badge/Quickshell-Qt_QML-41CD52?style=for-the-badge)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Tmux](https://img.shields.io/badge/Tmux-1BB91F?style=for-the-badge&logo=tmux&logoColor=white)

---

## 🌟 Highlights & Features

- **📦 Completely Self-Contained `dotconfig/`**: Everything (desktop configurations, shell dotfiles, helper scripts, wallpapers, git repo, installer, and documentation) lives inside this single directory.
- **🧠 Automatic Target Detection**: The installer intelligently classifies files inside `dotconfig/`:
  - Home dotfiles (`.bashrc`, `.bash_profile`, `.zshrc`) are automatically deployed to `~`.
  - Desktop configs (`hypr`, `kitty`, `nvim`, `waybar`, `starship.toml`, etc.) are automatically deployed to `~/.config`.
  - Helper scripts (`scripts/`) are automatically deployed to `~/.local/bin`.
  - Wallpaper collection (`wallpapers/`) is automatically deployed to `~/Pictures/wallpapers`.
- **🎨 Dynamic Material Theme Generation**: Seamlessly syncs color schemes across Quickshell, terminals, and desktop widgets based on the active wallpaper using `matugen` and `qs-theme-bridge`.
- **🎲 One-Touch Wallpaper Switcher**: Press `Super + F1` to shuffle through 50+ curated high-resolution wallpapers and regenerate colors on the fly.
- **⚡ Quickshell Rise & Waybar**: Sleek status bar with live system monitoring, media controls, workspace indicators, and power profiles.
- **💻 Tailored Terminal Setup**:
  - **Kitty**, **Ghostty**, and **Alacritty** configured with JetBrainsMono Nerd Font.
  - **Neovim**: Modular configuration managed by `lazy.nvim` with Treesitter, LSP, and Telescope.
  - **Tmux**: Vi-keybindings, sessionizer (`tmux-sessionizer.sh`), CPU/Mem monitor, and TPM plugin manager.
  - **Starship Prompt**: Custom floating pill design with git status and execution timing.
- **📸 Screenshot & Screen Recording**:
  - `Super + P`: Interactive region screenshot annotated in Swappy.
  - `Super + Alt + P`: Fullscreen capture.
  - `Super + Ctrl + P`: Direct-to-clipboard screenshot.
  - `Super + F9` / `Super + F10`: Hardware-accelerated screen recording with `wf-recorder`.
- **🚀 Portable & Multi-User Ready**: Contains zero hardcoded paths; `install.sh` automatically detects the installing user's `$HOME`, `$USER`, and directory hierarchy.

---

## 📁 Repository Structure

```
dotconfig/
├── install.sh                 # Intelligent self-contained installer
├── README.md                  # Documentation & keybindings reference
├── .gitignore                 # Git ignore rules for clean repo tracking
├── .git/                      # Git version control repository
├── .bashrc                    # 🧠 Auto-dispatched to ~/.bashrc
├── .bash_profile             # 🧠 Auto-dispatched to ~/.bash_profile
├── .zshrc                     # 🧠 Auto-dispatched to ~/.zshrc
├── scripts/                   # 🧠 Auto-dispatched to ~/.local/bin
│   ├── kitty-tmux             # Launch Kitty terminal attached to Tmux session
│   ├── omarchy-launch-*       # Floating terminal helper for presentations/scripts
│   ├── omarchy-theme-bg-set   # Apply wallpaper via swaybg & update symlinks
│   ├── omarchy-theme-set      # Switch active theme by name
│   ├── qs-arch-apply-update   # Safe package updater integration
│   ├── qs-barctl              # Quickshell bar control daemon
│   ├── qs-proj                # Quickshell layout switcher (v1/v2)
│   ├── qs-theme-bridge        # Generate colors.toml from wallpaper using matugen
│   ├── tmux-sessionizer.sh    # Interactive project/directory tmux session picker
│   └── wallpaper-change.sh    # Super+F1 random wallpaper & theme generator
├── wallpapers/                # 🧠 Auto-dispatched to ~/Pictures/wallpapers (50+ walls)
│   ├── wallhaven-9orlxx.jpg   # Primary active theme wallpaper
│   └── ...
├── alacritty/                 # Alacritty terminal styling -> ~/.config/alacritty
├── btop/                      # Resource monitor config -> ~/.config/btop
├── cachyos/                   # CachyOS system integrations -> ~/.config/cachyos
├── cava/                      # Audio visualizer shaders and gradients -> ~/.config/cava
├── copyq/                     # Clipboard manager rules & appearance -> ~/.config/copyq
├── dolphinrc                  # KDE Dolphin file manager settings -> ~/.config/dolphinrc
├── fastfetch/                 # System info fetch & custom ASCII art -> ~/.config/fastfetch
├── fish/                      # Fish shell configs & colors -> ~/.config/fish
├── ghostty/                   # Ghostty terminal config -> ~/.config/ghostty
├── gtk-3.0/ & gtk-4.0/        # Modern dark GTK styling -> ~/.config/gtk-*
├── hypr/                      # Hyprland core (Lua config, binds, rules) -> ~/.config/hypr
├── hyprpaper.conf             # Wallpaper daemon config -> ~/.config/hyprpaper.conf
├── kdeglobals                 # Qt/KDE application color palette -> ~/.config/kdeglobals
├── kitty/                     # Kitty terminal config, fonts, themes -> ~/.config/kitty
├── matugen/                   # Material color extraction templates -> ~/.config/matugen
├── micro/                     # Micro terminal editor settings -> ~/.config/micro
├── networkmanager-dmenu/      # Wi-Fi / VPN selector via Rofi -> ~/.config/...
├── noctalia/                  # Noctalia bar & shell settings -> ~/.config/noctalia
├── nvim/                      # Full modular Neovim setup (Lua / Lazy) -> ~/.config/nvim
├── nwg-look/                  # GTK theme switcher integration -> ~/.config/nwg-look
├── obs-studio/                # OBS streaming & recording profiles -> ~/.config/obs-studio
├── omarchy/                   # Dynamic theme state & hooks -> ~/.config/omarchy
├── qt5ct/ & qt6ct/            # Qt5 and Qt6 theming & palettes -> ~/.config/qt*ct
├── quickshell/                # Quickshell Rise bar, widgets, QML -> ~/.config/quickshell
├── qView/                     # Minimalist image viewer settings -> ~/.config/qView
├── rofi/                      # App launcher, dmenu, and window switcher -> ~/.config/rofi
├── starship.toml              # Starship prompt configuration -> ~/.config/starship.toml
├── swappy/                    # Screenshot annotation tool settings -> ~/.config/swappy
├── swash/                     # Screenshot markup preferences -> ~/.config/swash
├── swaync/                    # Notification center & control center -> ~/.config/swaync
├── systemd/                   # User services and timers -> ~/.config/systemd
├── Thunar/                    # Thunar custom actions and accels -> ~/.config/Thunar
├── tmux/                      # Tmux configuration and cheatsheet -> ~/.config/tmux
├── waybar/                    # Modular Waybar status bar & style -> ~/.config/waybar
├── wlogout/                   # Power menu layout, styling, icons -> ~/.config/wlogout
└── yazi/                      # Terminal file manager configuration -> ~/.config/yazi
```

---

## 🚀 Installation Guide

### 1. Clone or Open the Repository

```bash
git clone <repo-url> ~/dotconfig
cd ~/dotconfig
```

### 2. Run the Installer

The installer automatically detects the current user's `$HOME`, scans `dotconfig/`, distinguishes home files from desktop configs, creates backups, establishes symlinks, and sets up permissions:

```bash
# Preview changes without modifying files (Dry Run)
./install.sh --dry-run

# Interactive installation
./install.sh

# Non-interactive mode (accept all defaults)
./install.sh -y

# Optional: Install required system packages automatically via pacman / paru / yay
./install.sh --install-pkgs
```

### 3. Installer Options

| Flag | Description |
| :--- | :--- |
| `-y`, `--yes`, `--non-interactive` | Run without prompts; accept all defaults. |
| `-n`, `--dry-run` | Show simulated installation actions without modifying files. |
| `--install-pkgs` | Automatically install missing Arch / AUR packages. |
| `--no-backup` | Skip backing up existing configs. |
| `--backup-dir <dir>` | Specify a custom backup destination. |
| `-h`, `--help` | Display usage instructions and path environment. |

---

## ⌨️ Keybindings Quick Reference

### Application Shortcuts

| Keybinding | Action |
| :--- | :--- |
| `Super + Return` / `Super + T` | Open Kitty terminal |
| `Super + M` / `Super + Space` | Open Rofi application launcher |
| `Super + B` | Open web browser |
| `Super + E` | Open Thunar file manager |
| `Super + V` | Toggle CopyQ clipboard history |
| `Super + L` | Lock screen with Hyprlock |
| `Super + Escape` | Open Wlogout power menu |
| `Super + I` | Open NetworkManager Wi-Fi selector |
| `Super + F1` | **Switch to a random wallpaper & regenerate theme colors** |
| `Super + W` | Toggle Quickshell status bar visibility |

### Window Management

| Keybinding | Action |
| :--- | :--- |
| `Super + Q` | Close active window |
| `Super + F` | Toggle maximized / fullscreen window |
| `Super + D` | Toggle floating state |
| `Super + G` | Toggle horizontal/vertical split orientation |
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
omarchy-theme-set wallhaven-9orlxx
```

---

## 📦 Required Dependencies

For manual package installation on Arch Linux / CachyOS:

```bash
# Core Compositor & Wayland
sudo pacman -S hyprland hypridle hyprlock hyprpaper xdg-desktop-portal-hyprland swaybg swaync polkit-gnome

# Audio & Hardware
sudo pacman -S wireplumber pipewire pipewire-pulse pipewire-alsa playerctl brightnessctl pamixer

# Tools & Utilities
sudo pacman -S kitty alacritty rofi wlogout starship neovim tmux fastfetch btop cava yazi eza fzf micro thunar wl-clipboard cliphist grim slurp swappy wf-recorder papirus-icon-theme ttf-jetbrains-mono-nerd

# AUR Packages
paru -S quickshell matugen-bin swayosd networkmanager-dmenu-git bibata-cursor-theme
```

---

## 💡 Post-Installation Notes

1. **Tmux Plugins**: Open `tmux` and press `Ctrl + Space` followed by `I` (capital i) to fetch and initialize all plugins through TPM.
2. **Fish / Bash**: If you use Fish, launch `fish` and run `fish_add_path ~/.local/bin`. For Bash, source `~/.bashrc`.
3. **Wayland Portal**: If screen sharing is needed in Chromium / Discord, `xdg-desktop-portal-hyprland` is included in the autostart sequence.
