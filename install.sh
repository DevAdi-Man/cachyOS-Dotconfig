#!/usr/bin/env bash
# ==============================================================================
#  Dotfiles & Rice Installer (dotconfig)
#  Hyprland • Quickshell • Omarchy • Waybar • Catppuccin / Dynamic Theme
# ==============================================================================

set -euo pipefail

# --- ANSI Styling ---
BOLD='\033[1m'
DIM='\033[2m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

info()    { printf "${CYAN}ℹ %s${RESET}\n" "$*"; }
success() { printf "${GREEN}✔ %s${RESET}\n" "$*"; }
warn()    { printf "${YELLOW}⚠ %s${RESET}\n" "$*"; }
error()   { printf "${RED}✖ %s${RESET}\n" "$*" >&2; }
head()    { printf "\n${BOLD}${MAGENTA}═══ %s ═══${RESET}\n" "$*"; }

# --- Detect Paths & Context ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_CONFIG_DIR="$SCRIPT_DIR"

# Detect real target user if run through sudo
if [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != "root" ]]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
else
    TARGET_USER="${USER:-$(id -un)}"
    TARGET_HOME="${HOME:-$(eval echo "~$TARGET_USER")}"
fi

if [[ -n "${XDG_CONFIG_HOME:-}" && "$XDG_CONFIG_HOME" == "$TARGET_HOME"* ]]; then
    TARGET_CONFIG="$XDG_CONFIG_HOME"
else
    TARGET_CONFIG="$TARGET_HOME/.config"
fi
TARGET_LOCAL_BIN="$TARGET_HOME/.local/bin"
TARGET_LOCAL_SHARE="$TARGET_HOME/.local/share"
TARGET_WALLPAPERS="$TARGET_HOME/Pictures/wallpapers"
TARGET_SCREENSHOTS="$TARGET_HOME/Pictures/Screenshots"

# --- Defaults & Flags ---
DRY_RUN=false
INTERACTIVE=true
SKIP_BACKUP=false
INSTALL_PKGS=false
BACKUP_DIR="$TARGET_HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

# Helper function: detect files meant for $TARGET_HOME (root of user profile)
is_home_target() {
    local fname="$1"
    case "$fname" in
        .bashrc|.bash_profile|.bash_logout|.zshrc|.profile|.vimrc|.zshenv)
            return 0
            ;;
        bashrc|bash_profile|zshrc)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Helper function: detect repo metadata that should not be copied to ~/.config
is_repo_metadata() {
    local fname="$1"
    case "$fname" in
        install.sh|README.md|.git|.gitignore|LICENSE|COPYING|scripts|wallpapers)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

usage() {
    cat <<EOF
Usage: ./install.sh [OPTIONS]

Options:
  -y, --yes, --non-interactive  Run without prompting, accept all defaults
  -n, --dry-run                 Preview what will be copied without making changes
  --no-backup                   Skip backing up existing configs
  --backup-dir DIR              Specify custom directory for backup
  --install-pkgs                Attempt to install system packages via paru/yay/pacman
  -h, --help                    Show this help message

Target Environment:
  User:           $TARGET_USER
  Home Directory: $TARGET_HOME
  Config Path:    $TARGET_CONFIG
  Local Bin:      $TARGET_LOCAL_BIN
  Wallpapers:     $TARGET_WALLPAPERS
  Source Folder:  $SOURCE_CONFIG_DIR
EOF
    exit 0
}

# Parse flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes|--non-interactive)
            INTERACTIVE=false
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=true
            INTERACTIVE=false
            shift
            ;;
        --no-backup)
            SKIP_BACKUP=true
            shift
            ;;
        --backup-dir)
            BACKUP_DIR="$2"
            shift 2
            ;;
        --install-pkgs)
            INSTALL_PKGS=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            warn "Unknown argument: $1"
            shift
            ;;
    esac
done

# --- Banner ---
printf "${CYAN}${BOLD}"
cat << 'EOF'
      _       _                  __ _       
   __| | ___ | |_ ___ ___  _ __  / _(_) __ _ 
  / _` |/ _ \| __/ __/ _ \| '_ \| |_| |/ _` |
 | (_| | (_) | || (_| (_) | | | |  _| | (_| |
  \__,_|\___/ \__\___\___/|_| |_|_| |_|\__, |
                                       |___/ 
EOF
printf "${RESET}\n"
info "Dotfiles Installation Script (dotconfig)"
info "Target User: ${BOLD}$TARGET_USER${RESET}"
info "Target Home: ${BOLD}$TARGET_HOME${RESET}"
info "Source Directory: ${BOLD}$SOURCE_CONFIG_DIR${RESET}"
echo

if [[ "$DRY_RUN" == true ]]; then
    warn "DRY-RUN MODE ENABLED. No filesystem modifications will be made."
    echo
fi

# Confirmation in interactive mode
if [[ "$INTERACTIVE" == true && "$DRY_RUN" == false ]]; then
    read -rp "Proceed with installation to $TARGET_HOME? [Y/n] " confirm
    confirm="${confirm:-y}"
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        info "Installation cancelled by user."
        exit 0
    fi
fi

# ==============================================================================
# 1. Package Installation (Optional)
# ==============================================================================
install_packages() {
    head "1. Checking System Packages"

    local aur_helper="paru"
    if ! command -v paru &>/dev/null; then
        info "paru not found. Installing paru via pacman..."
        sudo pacman -S --needed --noconfirm paru || warn "Failed to install paru, package installation might fail."
    fi

    local core_pkgs=(
        hyprland hypridle hyprlock hyprpaper xdg-desktop-portal-hyprland
        swaybg swaync kitty alacritty rofi wlogout starship
        neovim tmux fastfetch btop cava yazi eza fzf micro
        thunar wl-clipboard cliphist grim slurp swappy wf-recorder
        brightnessctl playerctl wireplumber pipewire
        papirus-icon-theme ttf-jetbrains-mono-nerd
    )

    local aur_pkgs=(
        quickshell matugen-bin swayosd networkmanager-dmenu-git
        bibata-cursor-theme
    )

    if [[ "$INSTALL_PKGS" == false && "$INTERACTIVE" == true ]]; then
        read -rp "Do you want to install missing packages via pacman/AUR? [y/N] " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            INSTALL_PKGS=true
        fi
    fi

    if [[ "$INSTALL_PKGS" == true ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            info "[Dry-Run] Would install core packages: ${core_pkgs[*]}"
            info "[Dry-Run] Would install AUR packages: ${aur_pkgs[*]}"
            return
        fi

        info "Updating repositories and checking packages..."
        if [[ -n "$aur_helper" ]]; then
            "$aur_helper" -S --needed --noconfirm "${core_pkgs[@]}" "${aur_pkgs[@]}" || warn "Some packages could not be installed automatically. Continuing..."
        else
            warn "No AUR helper (paru/yay) detected. Installing official packages via pacman..."
            sudo pacman -S --needed --noconfirm "${core_pkgs[@]}" || warn "Failed to install some official packages."
        fi
        success "Package step completed."
    else
        info "Skipping package installation (use --install-pkgs to enable)."
    fi
}

# ==============================================================================
# 2. Backup Existing Configurations
# ==============================================================================
backup_configs() {
    head "2. Backing Up Existing Configurations"

    if [[ "$SKIP_BACKUP" == true ]]; then
        info "Skipping backup as requested."
        return
    fi

    local config_backups=()
    local home_backups=()

    # Scan dotconfig directory (including hidden files)
    shopt -s nullglob dotglob
    for item in "$SOURCE_CONFIG_DIR"/*; do
        local base
        base="$(basename "$item")"

        # Skip installer, readme, git metadata, and external dirs
        if is_repo_metadata "$base"; then
            continue
        fi

        if is_home_target "$base"; then
            local target_name="$base"
            [[ "$target_name" != .* ]] && target_name=".$target_name"
            if [[ -e "$TARGET_HOME/$target_name" ]]; then
                home_backups+=("$target_name")
            fi
        else
            if [[ -e "$TARGET_CONFIG/$base" ]]; then
                config_backups+=("$base")
            fi
        fi
    done
    shopt -u nullglob dotglob

    local total_conflicts=$((${#config_backups[@]} + ${#home_backups[@]}))
    if [[ $total_conflicts -eq 0 ]]; then
        info "No conflicting configurations found. No backup needed."
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        info "[Dry-Run] Would backup $total_conflicts items (${#config_backups[@]} in .config, ${#home_backups[@]} in ~) to $BACKUP_DIR"
        return
    fi

    info "Backing up $total_conflicts existing items to: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR/.config" "$BACKUP_DIR/home"
    for base in "${config_backups[@]}"; do
        cp -a "$TARGET_CONFIG/$base" "$BACKUP_DIR/.config/"
    done
    for base in "${home_backups[@]}"; do
        cp -a "$TARGET_HOME/$base" "$BACKUP_DIR/home/"
    done
    success "Backup saved in $BACKUP_DIR"
}

# ==============================================================================
# 3. Create Required Directory Hierarchy
# ==============================================================================
create_directories() {
    head "3. Creating Directory Hierarchy"

    local dirs=(
        "$TARGET_CONFIG"
        "$TARGET_LOCAL_BIN"
        "$TARGET_LOCAL_SHARE/omarchy/themes"
        "$TARGET_WALLPAPERS"
        "$TARGET_SCREENSHOTS"
        "$TARGET_HOME/Videos/Screencasts"
        "$TARGET_CONFIG/omarchy/current/theme"
    )

    for d in "${dirs[@]}"; do
        if [[ "$DRY_RUN" == true ]]; then
            info "[Dry-Run] Would create directory: $d"
        else
            mkdir -p "$d"
        fi
    done
    success "Directory hierarchy prepared."
}

# ==============================================================================
# 4. Auto-Install Configurations (Automatically Understands ~ vs ~/.config)
# ==============================================================================
install_configs() {
    head "4. Auto-Classifying & Installing from $(basename "$SOURCE_CONFIG_DIR")"

    if [[ "$DRY_RUN" == true ]]; then
        info "[Dry-Run] Auto-classifying and dispatching files from $SOURCE_CONFIG_DIR:"
    fi

    shopt -s nullglob dotglob
    for item in "$SOURCE_CONFIG_DIR"/*; do
        local name
        name="$(basename "$item")"

        # Skip installer metadata, git files, and sub-managers
        if is_repo_metadata "$name"; then
            continue
        fi

        # ── Category A: Shell / Home Dotfiles ──────────────────────────────
        if is_home_target "$name"; then
            local dest_file="$name"
            [[ "$dest_file" != .* ]] && dest_file=".$dest_file"

            if [[ "$DRY_RUN" == true ]]; then
                printf "  ${DIM}• [Home File]   %s -> %s/%s${RESET}\n" "$name" "$TARGET_HOME" "$dest_file"
            else
                cp -f "$item" "$TARGET_HOME/$dest_file"
                printf "  ${DIM}• Installed to ~/%s${RESET}\n" "$dest_file"
            fi

        # ── Category B: All other desktop config files/directories ────────
        else
            if [[ "$DRY_RUN" == true ]]; then
                printf "  ${DIM}• [.config]     %s -> %s/%s${RESET}\n" "$name" "$TARGET_CONFIG" "$name"
            else
                if [[ -d "$item" ]]; then
                    mkdir -p "$TARGET_CONFIG/$name"
                    cp -rT "$item" "$TARGET_CONFIG/$name"
                else
                    cp -f "$item" "$TARGET_CONFIG/$name"
                fi
            fi
        fi
    done
    shopt -u nullglob dotglob

    if [[ "$DRY_RUN" == true ]]; then
        return
    fi
    success "Configurations successfully dispatched."

    # --- Path Localization Step ---
    info "Adapting configuration paths to target home ($TARGET_HOME)..."

    # 1. wlogout style.css (icon URLs)
    if [[ -f "$TARGET_CONFIG/wlogout/style.css" ]]; then
        sed -i "s|__USER_HOME__|$TARGET_HOME|g" "$TARGET_CONFIG/wlogout/style.css"
    fi

    # 2. swappy config (save_dir)
    if [[ -f "$TARGET_CONFIG/swappy/config" ]]; then
        sed -i "s|__USER_HOME__|$TARGET_HOME|g" "$TARGET_CONFIG/swappy/config"
    fi

    # 3. hyprpaper configs
    if [[ -f "$TARGET_CONFIG/hyprpaper.conf" ]]; then
        sed -i "s|__USER_HOME__|$TARGET_HOME|g" "$TARGET_CONFIG/hyprpaper.conf"
    fi
    if [[ -f "$TARGET_CONFIG/hypr/hyprpaper.conf" ]]; then
        sed -i "s|__USER_HOME__|$TARGET_HOME|g" "$TARGET_CONFIG/hypr/hyprpaper.conf"
    fi

    # 4. hyprlock config
    if [[ -f "$TARGET_CONFIG/hypr/hyprlock.conf" ]]; then
        sed -i "s|__USER_HOME__|$TARGET_HOME|g" "$TARGET_CONFIG/hypr/hyprlock.conf"
    fi

    # 5. fish config
    if [[ -f "$TARGET_CONFIG/fish/fish_variables" ]]; then
        sed -i "s|__USER_HOME__|$TARGET_HOME|g" "$TARGET_CONFIG/fish/fish_variables"
    fi

    # 6. obs-studio configs
    if [[ -f "$TARGET_CONFIG/obs-studio/global.ini" ]]; then
        sed -i "s|__USER_HOME__|$TARGET_HOME|g" "$TARGET_CONFIG/obs-studio/global.ini"
    fi
    if [[ -f "$TARGET_CONFIG/obs-studio/basic/profiles/Untitled/basic.ini" ]]; then
        sed -i "s|__USER_HOME__|$TARGET_HOME|g" "$TARGET_CONFIG/obs-studio/basic/profiles/Untitled/basic.ini"
    fi

    # 7. Make internal scripts in .config executable
    chmod +x "$TARGET_CONFIG"/hypr/scripts/*.sh 2>/dev/null || true
    chmod +x "$TARGET_CONFIG"/quickshell/*.sh 2>/dev/null || true
    chmod +x "$TARGET_CONFIG"/quickshell/bin/* 2>/dev/null || true
    chmod +x "$TARGET_CONFIG"/quickshell/bar/core/*.sh 2>/dev/null || true
    chmod +x "$TARGET_CONFIG"/omarchy/hooks/theme-set.d/*.sh 2>/dev/null || true

    success "Path localization completed for $TARGET_USER."
}

# ==============================================================================
# 5. Install Custom Helper Scripts (.local/bin)
# ==============================================================================
install_scripts() {
    head "5. Installing Custom Scripts (.local/bin)"

    local scripts_src="$SCRIPT_DIR/scripts"

    if [[ ! -d "$scripts_src" ]]; then
        info "No scripts directory found in $SCRIPT_DIR."
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        info "[Dry-Run] Would copy scripts from $scripts_src to $TARGET_LOCAL_BIN and make executable"
        return
    fi

    for script in "$scripts_src"/*; do
        if [[ -f "$script" ]]; then
            local sname
            sname="$(basename "$script")"
            cp -f "$script" "$TARGET_LOCAL_BIN/$sname"
            chmod +x "$TARGET_LOCAL_BIN/$sname"
            printf "  ${DIM}• Installed: %s${RESET}\n" "$sname"
        fi
    done
    success "Scripts installed to $TARGET_LOCAL_BIN."
}

# ==============================================================================
# 6. Install Wallpapers & Setup Omarchy Theme
# ==============================================================================
install_wallpapers_and_themes() {
    head "6. Installing Wallpapers & Configuring Theme"

    local wall_src="$SCRIPT_DIR/wallpapers"

    if [[ -d "$wall_src" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            info "[Dry-Run] Would copy wallpapers from $wall_src to $TARGET_WALLPAPERS"
        else
            info "Copying wallpaper collection to $TARGET_WALLPAPERS..."
            cp -rn "$wall_src"/* "$TARGET_WALLPAPERS/" 2>/dev/null || cp -r "$wall_src"/* "$TARGET_WALLPAPERS/"
            success "Wallpapers installed."
        fi
    else
        warn "No wallpapers directory found in $SCRIPT_DIR."
    fi

    if [[ "$DRY_RUN" == true ]]; then
        info "[Dry-Run] Would configure active Omarchy theme and symlinks"
        return
    fi

    # Set default theme wallpaper
    local default_wall="$TARGET_WALLPAPERS/wallhaven-9orlxx.jpg"
    if [[ ! -f "$default_wall" ]]; then
        default_wall="$(find "$TARGET_WALLPAPERS" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) | head -n 1 || true)"
    fi

    if [[ -n "$default_wall" && -f "$default_wall" ]]; then
        # Setup omarchy background symlink
        mkdir -p "$TARGET_CONFIG/omarchy/current"
        ln -sf "$default_wall" "$TARGET_CONFIG/omarchy/current/background"

        # Setup omarchy backgrounds directory symlink
        ln -sfn "$TARGET_WALLPAPERS" "$TARGET_CONFIG/omarchy/current/theme/backgrounds"

        # Theme name
        local theme_name
        theme_name="$(basename "$default_wall" | sed 's/\.[^.]*$//')"
        echo "$theme_name" > "$TARGET_CONFIG/omarchy/current/theme.name"

        info "Active theme wallpaper set to: $(basename "$default_wall")"

        # Generate Omarchy theme directory structure for all wallpapers
        info "Registering themes in $TARGET_LOCAL_SHARE/omarchy/themes..."
        for wall in "$TARGET_WALLPAPERS"/*; do
            if [[ -f "$wall" ]]; then
                local wfile
                wfile="$(basename "$wall")"
                local tname="${wfile%.*}"
                local tdir="$TARGET_LOCAL_SHARE/omarchy/themes/$tname/backgrounds"
                mkdir -p "$tdir"
                ln -sf "$wall" "$tdir/$wfile"
            fi
        done
        success "Omarchy theme catalog synchronized."

        # If matugen and qs-theme-bridge are available, generate initial colors
        if command -v matugen &>/dev/null && [[ -x "$TARGET_LOCAL_BIN/qs-theme-bridge" ]]; then
            info "Generating color palette via qs-theme-bridge..."
            python3 "$TARGET_LOCAL_BIN/qs-theme-bridge" "$default_wall" >/dev/null 2>&1 || true
        fi
    fi
}

# ==============================================================================
# 7. Shell Integration (PATH Check in .bashrc & .zshrc)
# ==============================================================================
setup_shell_integration() {
    head "7. Configuring Shell Environment"

    local path_export='export PATH="$HOME/.local/bin:$PATH"'

    for rc in "$TARGET_HOME/.bashrc" "$TARGET_HOME/.zshrc"; do
        if [[ -f "$rc" ]]; then
            if ! grep -q '\.local/bin' "$rc"; then
                if [[ "$DRY_RUN" == true ]]; then
                    info "[Dry-Run] Would ensure ~/.local/bin is exported in $rc"
                else
                    echo -e "\n# Added by Rice Installer\n$path_export" >> "$rc"
                    success "Verified ~/.local/bin in $rc"
                fi
            fi
        fi
    done
}

# ==============================================================================
# 8. Tmux Plugin Manager (TPM) Setup
# ==============================================================================
setup_tmux() {
    head "8. Setting Up Tmux Plugin Manager"

    local tpm_dir="$TARGET_HOME/.tmux/plugins/tpm"
    if [[ ! -d "$tpm_dir" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            info "[Dry-Run] Would clone TPM from GitHub to $tpm_dir"
        else
            info "Cloning Tmux Plugin Manager (TPM)..."
            git clone --quiet https://github.com/tmux-plugins/tpm "$tpm_dir" || warn "Could not clone TPM. Network might be offline."
            if [[ -d "$tpm_dir" ]]; then
                success "TPM installed."
            fi
        fi
    else
        info "TPM is already installed at $tpm_dir."
    fi
}

# ==============================================================================
# 9. Systemd User Services & Timers
# ==============================================================================
setup_systemd() {
    head "9. Enabling Background User Services & Timers"

    if [[ "$DRY_RUN" == true ]]; then
        info "[Dry-Run] Would reload systemd --user and enable update timers"
        return
    fi

    if command -v systemctl &>/dev/null && systemctl --user is-active --quiet default.target 2>/dev/null; then
        systemctl --user daemon-reload || true
        systemctl --user enable --now qs-shell-update-check.timer 2>/dev/null || true
        systemctl --user enable --now qs-aur-blacklist-fetch.timer 2>/dev/null || true
        success "Systemd user timers enabled."
    else
        info "Systemd user instance not running or unavailable. Timers can be enabled later."
    fi
}

# ==============================================================================
# Main Execution Flow
# ==============================================================================
main() {
    install_packages
    backup_configs
    create_directories
    install_configs
    install_scripts
    install_wallpapers_and_themes
    setup_shell_integration
    setup_tmux
    setup_systemd

    head "Installation Complete!"
    printf "${GREEN}${BOLD}All configurations, scripts, and wallpapers have been successfully installed.${RESET}\n\n"
    printf "Summary of key components:\n"
    printf "  • Root Project   : ${CYAN}%s${RESET}\n" "$SOURCE_CONFIG_DIR"
    printf "  • Configurations : ${CYAN}%s${RESET}\n" "$TARGET_CONFIG"
    printf "  • Shell Dotfiles : ${CYAN}%s (.bashrc, .zshrc, etc.)${RESET}\n" "$TARGET_HOME"
    printf "  • Helper Scripts : ${CYAN}%s${RESET}\n" "$TARGET_LOCAL_BIN"
    printf "  • Wallpapers     : ${CYAN}%s${RESET}\n" "$TARGET_WALLPAPERS"
    printf "  • Primary Theme  : ${CYAN}wallhaven-9orlxx${RESET}\n"
    if [[ "$SKIP_BACKUP" == false && -d "$BACKUP_DIR" ]]; then
        printf "  • Backup Folder  : ${YELLOW}%s${RESET}\n" "$BACKUP_DIR"
    fi
    echo
    printf "${BOLD}Quick Tips:${RESET}\n"
    printf "  • Press ${CYAN}Super + F1${RESET} in Hyprland to cycle through wallpapers and dynamic themes.\n"
    printf "  • Press ${CYAN}Super + Return${RESET} to open Kitty terminal.\n"
    printf "  • Press ${CYAN}Super + M${RESET} or ${CYAN}Super + Space${RESET} to open the Rofi app launcher.\n"
    printf "  • In Tmux, press ${CYAN}Ctrl + Space${RESET} followed by ${CYAN}I${RESET} to install all plugins.\n"
    printf "  • Run ${CYAN}omarchy-theme-set <theme-name>${RESET} to apply any wallpaper theme.\n"
    echo
}

main
