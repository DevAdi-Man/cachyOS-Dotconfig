#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export PATH="$HOME/.local/bin:$PATH"
alias cls="clear"
alias n="nvim ."
alias reload="source ~/.bashrc"
alias lla="eza -a -lh --icons=always --git --group-directories-first"
alias ls="eza --icons=always"
alias ll="eza --icons=always -lh --git"
alias la="eza --icons=always -lah --git"
alias lt="eza --icons=always --tree --level=2"
alias lta="eza --icons=always --tree --level=2 -a"

alias del="rm -rf"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

# Android SDK
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export LANG=en_IN.UTF-8
export LC_ALL=en_IN.UTF-8

# Android Emulator
alias emulator='QT_QPA_PLATFORM=xcb /home/devadi/Android/Sdk/emulator/emulator -avd Pixel_8 -gpu host -scale 0.4 -no-boot-anim -no-skin'

# Added by Antigravity CLI installer
export PATH="/home/devadi/.local/bin:$PATH"

# Enable zoxide for cd
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --cmd cd)"
fi

# SDDM Astronaut Theme Aliases
alias sddm-edit="sudo nvim /usr/share/sddm/themes/sddm-astronaut-theme/Themes/japanese_aesthetic.conf"
alias sddm-preview="sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme/"

alias openpdf='zen-browser'
alias y='yazi'
alias pod='podman-compose'

# ADB Wifi Connect Function
function adb_wifi() {
    # Start server to prevent 'protocol fault' bug during pairing
    adb start-server
    echo "Select Device to connect:"
    echo "1) 192.168.31.45 (New)"
    echo "2) 192.168.31.39 (Old)"
    read -p "Enter choice (1 or 2) [Default: 1]: " ip_choice

    if [ "$ip_choice" == "2" ]; then
        IP="192.168.31.39"
    else
        IP="192.168.31.45"
    fi

    echo "Device IP is set to: $IP"
    read -p "Enter Pairing Port (from 'Pair device with pairing code' screen): " PAIR_PORT
    read -p "Enter Pairing Code: " PAIR_CODE

    echo "Pairing with $IP:$PAIR_PORT..."
    adb pair $IP:$PAIR_PORT $PAIR_CODE

    echo "----------------------------------------"
    read -p "Enter Connect Port (from main Wireless Debugging screen): " CONNECT_PORT

    echo "Connecting to $IP:$CONNECT_PORT..."
    adb connect $IP:$CONNECT_PORT

    echo "Done! Attached devices:"
    adb devices
}

# starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
