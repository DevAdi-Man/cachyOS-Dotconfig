#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# Added by swiftly
[[ ! -r "$HOME/.local/share/swiftly/env.sh" ]] || . "$HOME/.local/share/swiftly/env.sh"
[[ ! -r "$HOME/.cargo/env" ]] || . "$HOME/.cargo/env"
