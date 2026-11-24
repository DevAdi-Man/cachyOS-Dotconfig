#!/usr/bin/env bash
set -Eeuo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
dry_run=false
assume_yes=false
backup=true
backup_dir=
packages=false

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'HELP'
Usage: ./install.sh [OPTIONS]

  -n, --dry-run          Preview the install without changing files or packages
  -y, --yes              Skip the confirmation prompt
  --install-pkgs         Update CachyOS and install desktop/editor dependencies
  --no-backup            Replace managed files without keeping a backup
  --backup-dir DIR       Use a new directory for backups
  -h, --help             Show this help
HELP
}

while (($#)); do
    case $1 in
        -n|--dry-run) dry_run=true ;;
        -y|--yes|--non-interactive) assume_yes=true ;;
        --install-pkgs) packages=true ;;
        --no-backup) backup=false ;;
        --backup-dir)
            (($# >= 2)) && [[ -n $2 && $2 != -* ]] || die '--backup-dir needs a directory'
            backup_dir=$2
            shift
            ;;
        -h|--help) usage; exit 0 ;;
        *) die "Unknown option $1" ;;
    esac
    shift
done

((EUID != 0)) || die 'Run as your desktop user. The package step invokes sudo itself.'
[[ ${HOME:-} == /* && -d $HOME ]] || die 'HOME must point to an existing directory'
config="$HOME/.config"
[[ ${XDG_CONFIG_HOME:-$config} == "$config" ]] ||
    die "This desktop config uses $config. Run with XDG_CONFIG_HOME unset or set to that path."
[[ $backup == true || -z $backup_dir ]] || die '--no-backup and --backup-dir are mutually exclusive'
if [[ -n $backup_dir ]]; then
    backup_dir=$(realpath -m -- "$backup_dir")
fi

home_files=(.bash_profile .bash_logout .bashrc .zshenv .zshrc)
config_entries=(
    Thunar alacritty btop cachyos cachyos-hello.json cava
    copyq/copyq-commands.ini copyq/copyq.conf dolphinrc fastfetch
    fish/conf.d/rashin.fish fish/conf.d/rustup.fish fish/config.fish fish/fish_variables
    fontconfig ghostty
    gtk-3.0/gtk.css gtk-3.0/noctalia.css gtk-3.0/settings.ini
    gtk-4.0/gtk.css gtk-4.0/noctalia.css gtk-4.0/settings.ini gtk-4.0/thumbnail.png
    hypr hyprpaper.conf kdeglobals kitty matugen menus micro mimeapps.list
    networkmanager-dmenu noctalia nvim nwg-look ohmyposh
    obs-studio/basic/profiles/Untitled/basic.ini obs-studio/basic/scenes/Untitled.json
    obs-studio/global.ini obs-studio/user.ini
    omarchy/current/theme.name omarchy/current/theme/colors.toml omarchy/hooks/theme-set.d/50-quickshell-bar.sh
    qView qt5ct qt6ct quickshell rofi starship.toml swappy swash swaync
    systemd/user/qs-aur-blacklist-fetch.service systemd/user/qs-aur-blacklist-fetch.timer
    systemd/user/qs-shell-update-check.service systemd/user/qs-shell-update-check.timer
    tmux/tmux.conf tmux/TMUX_CHEATSHEET.md user-dirs.dirs user-dirs.locale
    uwsm waybar wireplumber wlogout xfce4 xsettingsd yazi
)
helpers=(
    gyotaku-toggle kitty-tmux omarchy-launch-audio omarchy-launch-floating-terminal-with-presentation
    omarchy-theme-bg-set omarchy-theme-set qs-arch-apply-update.sh qs-arch-security-gate.sh
    qs-arch-update-check.sh qs-aur-blacklist-fetch.sh qs-proj qs-theme-bridge
    tmux-sessionizer.sh wallpaper-change.sh
)
tmux_plugins=(tpm tmux-continuum tmux-cpu-mem-monitor tmux-resurrect vim-tmux-navigator)
sync_packages=(
    base-devel bash git curl unzip jq python nodejs npm ripgrep fd tree-sitter-cli
    hyprland hypridle hyprlock hyprpaper hyprshot uwsm xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
    quickshell qt6-wayland qt6-5compat qt6ct polkit-gnome swaybg swaync swayosd
    pipewire pipewire-pulse wireplumber upower power-profiles-daemon networkmanager
    brightnessctl playerctl wl-clipboard cliphist grim slurp swappy wf-recorder
    thunar udiskie blueman copyq kitty alacritty rofi wlogout libnotify
    neovim imagemagick lua51 tmux fastfetch btop cava yazi ffmpeg eza fzf micro zoxide atuin lazygit
    obs-studio ghostty nwg-look qview zen-browser-bin bibata-cursor-theme
    fish zsh cachyos-zsh-config starship pacman-contrib matugen
    breeze-icons papirus-icon-theme adwaita-icon-theme ttf-jetbrains-mono-nerd noto-fonts
)
aur_packages=(oh-my-posh-bin networkmanager-dmenu-git)

localized_configs=(
    hypr/hyprlock.conf hypr/hyprpaper.conf hyprpaper.conf quickshell/lockscreen/LockSurface.qml
    Thunar/uca.xml swappy/config wlogout/style.css obs-studio/global.ini obs-studio/user.ini
    obs-studio/basic/profiles/Untitled/basic.ini obs-studio/basic/scenes/Untitled.json
)
declare -A localize=()
for entry in "${localized_configs[@]}"; do localize["$entry"]=1; done
escaped_home=$(printf '%s' "$HOME" | sed 's/[\\&|]/\\&/g')

install_packages() {
    local helper=
    local -a required_aur=("${aur_packages[@]}")
    if command -v paru >/dev/null; then
        helper=paru
    elif command -v yay >/dev/null; then
        helper=yay
    else
        sync_packages+=(paru)
        helper=paru
    fi

    if command -v oh-my-posh >/dev/null || [[ -x $HOME/.local/bin/oh-my-posh ]]; then
        required_aur=("${aur_packages[@]:1}")
    fi
    if $dry_run; then
        printf 'Would run sudo pacman -Syu --needed %s\n' "${sync_packages[*]}"
        printf 'Would run %s -S --needed %s\n' "$helper" "${required_aur[*]}"
        return
    fi

    [[ -x /usr/bin/pacman ]] || die '--install-pkgs requires CachyOS with pacman'
    sudo pacman -Syu --needed "${sync_packages[@]}"
    "$helper" -S --needed "${required_aur[@]}"
}

backup_target() {
    local target=$1 copy
    $backup || return 0
    if [[ $backup_ready == false ]]; then
        if [[ -n $backup_dir ]]; then
            mkdir -p -- "$(dirname -- "$backup_dir")"
            mkdir -m 700 -- "$backup_dir"
        else
            backup_dir=$(mktemp -d -- "$HOME/.config_backup_$(date +%Y%m%d_%H%M%S).XXXXXX")
        fi
        backup_ready=true
        printf 'Backing up replaced paths in %s\n' "$backup_dir"
    fi
    copy="$backup_dir/${target#"$HOME"/}"
    mkdir -p -- "$(dirname -- "$copy")"
    cp -aT --reflink=auto -- "$target" "$copy"
}

cleanup() {
    [[ -n $scratch ]] || return 0
    if [[ -e $scratch/previous || -L $scratch/previous ]]; then
        if [[ ! -e $pending_target && ! -L $pending_target ]]; then
            mv -T -- "$scratch/previous" "$pending_target" || {
                printf 'Recover the previous file from %s/previous\n' "$scratch" >&2
                return 1
            }
        fi
    fi
    rm -rf -- "$scratch"
    scratch=
}

# Build each replacement next to its destination before moving the old path.
deploy() {
    local source=$1 target=$2 kind=${3:-copy} relative template
    if [[ $kind == link ]]; then
        [[ -L $target && $(readlink -- "$target") == "$source" ]] && return 0
    else
        [[ -e $source || -L $source ]] || die "Missing source file $source"
        if [[ -f $source && ! -L $source && -f $target && ! -L $target &&
            ! ${localize[${source#"$repo"/}]+known} && $(stat -c %a -- "$source") == "$(stat -c %a -- "$target")" ]] &&
            cmp -s -- "$source" "$target"; then
            return 0
        fi
    fi
    if $dry_run; then
        [[ $kind == quiet ]] || printf 'Would install %s\n' "$target"
        return
    fi
    local target_parent
    target_parent=$(realpath -m -- "$(dirname -- "$target")")
    [[ $target_parent != "$repo" && $target_parent != "$repo/"* ]] ||
        die "Destination points into the source checkout: $target"
    if [[ -n $backup_dir && ( $backup_dir == "$target" || $backup_dir == "$target/"* ) ]]; then
        die "Backup directory is inside a managed path: $backup_dir"
    fi

    mkdir -p -- "$(dirname -- "$target")"
    pending_target=$target
    scratch=$(mktemp -d -- "$(dirname -- "$target")/.dotconfig.XXXXXX")
    if [[ $kind == link ]]; then
        ln -s -- "$source" "$scratch/next"
    else
        cp -aT --reflink=auto -- "$source" "$scratch/next"
        relative=${source#"$repo"/}
        for template in "${localized_configs[@]}"; do
            if [[ $template == "$relative" ]]; then
                sed -i "s|__USER_HOME__|$escaped_home|g" "$scratch/next"
            elif [[ $template == "$relative/"* ]]; then
                sed -i "s|__USER_HOME__|$escaped_home|g" "$scratch/next/${template#"$relative"/}"
            fi
        done
    fi

    if [[ -e $target || -L $target ]]; then
        if [[ -d $scratch/next && ! -L $scratch/next && -d $target && ! -L $target ]] &&
            diff -qr --no-dereference -- "$scratch/next" "$target" >/dev/null; then
            # Compare executable permissions as well as contents.
            if diff -q <(cd -- "$scratch/next" && find . -printf '%y %m %p\n' | sort) \
                       <(cd -- "$target" && find . -printf '%y %m %p\n' | sort) >/dev/null; then
                cleanup
                return
            fi
        elif [[ -f $scratch/next && ! -L $scratch/next && -f $target && ! -L $target &&
            $(stat -c %a -- "$scratch/next") == "$(stat -c %a -- "$target")" ]] &&
            cmp -s -- "$scratch/next" "$target"; then
            cleanup
            return
        fi
        backup_target "$target"
        mv -T -- "$target" "$scratch/previous"
    fi
    mv -T -- "$scratch/next" "$target"
    cleanup
}

setup_wallpapers() {
    local wall name theme wallpaper_dir="$HOME/Pictures/wallpapers"
    local -a walls=("$repo/wallpapers/"*)
    printf '%s %d wallpapers under %s\n' "$(if $dry_run; then echo 'Would install'; else echo 'Installing'; fi)" \
        "${#walls[@]}" "$wallpaper_dir"
    if ! $dry_run; then
        for wall in "${walls[@]}"; do
            [[ -f $wall && ! -L $wall ]] || continue
            name=${wall##*/}
            deploy "$wall" "$wallpaper_dir/$name" quiet
            theme="$HOME/.local/share/omarchy/themes/${name%.*}/backgrounds"
            deploy "$wallpaper_dir/$name" "$theme/$name" link
        done
    fi
    deploy "$wallpaper_dir/mono.png" "$config/omarchy/current/background" link
    # Keep the snapshot's background catalog in one directory on the target.
    deploy "$wallpaper_dir" "$config/omarchy/current/theme/backgrounds" link
}

for entry in "${home_files[@]}" "${config_entries[@]}" "${helpers[@]/#/scripts/}" \
    "${tmux_plugins[@]/#/tmux/plugins/}" "${localized_configs[@]}" \
    fonts/recursive/LICENSE.txt fonts/recursive/Recursive_VF_1.085.ttf \
    quickshell/bar/shell.qml nvim/init.lua hypr/hyprland.lua wallpapers/mono.png; do
    [[ -e $repo/$entry ]] || die "Missing source file $repo/$entry"
done

printf 'Installing current CachyOS dotfiles for %s\n' "$HOME"
if ! $dry_run && ! $assume_yes; then
    read -r -p 'Continue? [y/N] ' answer
    [[ $answer == [Yy] ]] || exit 0
fi

backup_ready=false
scratch=
pending_target=
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'printf "Installation stopped at line %s. Backup: %s\n" "$LINENO" "${backup_dir:-none}" >&2' ERR

if ! $dry_run; then
    exec 9<"$HOME"
    flock -n 9 || die 'Another dotfiles install is running for this HOME'
fi
if $packages; then install_packages; fi
for entry in "${home_files[@]}"; do deploy "$repo/$entry" "$HOME/$entry"; done
for entry in "${config_entries[@]}"; do deploy "$repo/$entry" "$config/$entry"; done
for entry in "${helpers[@]}"; do deploy "$repo/scripts/$entry" "$HOME/.local/bin/$entry"; done
for entry in "${tmux_plugins[@]}"; do
    [[ -d $HOME/.tmux/plugins/$entry ]] || deploy "$repo/tmux/plugins/$entry" "$HOME/.tmux/plugins/$entry"
done
for entry in LICENSE.txt Recursive_VF_1.085.ttf; do
    deploy "$repo/fonts/recursive/$entry" "$HOME/.local/share/fonts/recursive/$entry"
done
setup_wallpapers
deploy ../qs-aur-blacklist-fetch.timer "$config/systemd/user/timers.target.wants/qs-aur-blacklist-fetch.timer" link
if [[ -d $HOME/.local/share/quickshell-dots/.git ]]; then
    deploy ../qs-shell-update-check.timer "$config/systemd/user/timers.target.wants/qs-shell-update-check.timer" link
fi

if $dry_run; then
    printf 'Dry run complete.\n'
    exit 0
fi

mkdir -p -- "$HOME/Pictures/Screenshots" "$HOME/Videos/Screencasts"
if command -v systemctl >/dev/null && systemctl --user daemon-reload 2>/dev/null; then
    printf 'Reloaded systemd user units. Enabled timers start with the next user session.\n'
fi
printf 'Installation complete. Start a new Hyprland session to load the desktop setup.\n'
