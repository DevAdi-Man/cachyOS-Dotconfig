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
alias emulator='QT_QPA_PLATFORM=xcb $HOME/Android/Sdk/emulator/emulator -avd Pixel_8 -gpu host -scale 0.4 -no-boot-anim -no-skin'


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# Enable zoxide for cd
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --cmd cd)"
fi
