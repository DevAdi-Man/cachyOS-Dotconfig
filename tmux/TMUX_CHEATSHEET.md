# Tmux Cheatsheet 🖥️

> **Prefix = `Ctrl + Space`**

---

## 📦 CLI Commands

```shell
# New named session
tmux new -s mysession

# Attach to session
tmux attach -t mysession

# List sessions
tmux ls

# Detach from terminal (not tmux)
tmux detach

# Kill specific session
tmux kill-session -t mysession

# Kill everything
tmux kill-server && rm -rf /tmp/tmux-*

# Show all global options
tmux show-options -g

# Show all keybindings
tmux list-keys

# Show all commands
tmux list-commands
```

---

## 🔌 Plugin Setup (TPM)

```shell
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

| Action | Key |
|--------|-----|
| Install plugins | `Prefix + I` |
| Update plugins | `Prefix + U` |
| Remove unused plugins | `Prefix + Alt + u` |

---

## 🗂️ Sessions

| Action | Key / Command |
|--------|---------------|
| New session | `tmux new -s name` |
| Attach session | `tmux attach -t name` |
| List & switch sessions | `Prefix + s` |
| Rename session | `Prefix + $` |
| Detach from session | `Prefix + d` |
| Save session (resurrect) | `Prefix + Ctrl + s` |
| Restore session (resurrect) | `Prefix + Ctrl + r` |
| Open sessionizer | `Ctrl + f` |

---

## 🪟 Windows

| Action | Key |
|--------|-----|
| New window (same path) | `Prefix + c` |
| Go to window by number | `Prefix + 0-9` |
| Next window | `Prefix + n` |
| Previous window | `Prefix + p` |
| Last window | `Prefix + ^` |
| See all windows | `Prefix + w` |
| Rename window | `Prefix + ,` |
| Kill window | `Prefix + k` (confirm) |
| Swap window left | `Prefix + Shift + ←` |
| Swap window right | `Prefix + Shift + →` |

---

## 🔲 Panes

| Action | Key |
|--------|-----|
| Split horizontal (right) | `Prefix + \` |
| Split vertical (down) | `Prefix + -` |
| Navigate pane left | `Alt + h` ya `Ctrl + h` |
| Navigate pane down | `Alt + j` ya `Ctrl + j` |
| Navigate pane up | `Alt + k` ya `Ctrl + k` |
| Navigate pane right | `Alt + l` ya `Ctrl + l` |
| Resize pane left | `Prefix + h` (repeatable) |
| Resize pane down | `Prefix + j` (repeatable) |
| Resize pane up | `Prefix + k` (repeatable) |
| Resize pane right | `Prefix + l` (repeatable) |
| Maximize / restore pane | `Prefix + m` |
| Kill current session | `Prefix + x` (confirm) |
| Kill server (all) | `Prefix + K` (confirm) |

---

## 📋 Copy Mode (Vi)

| Action | Key |
|--------|-----|
| Enter copy mode | `Prefix + [` |
| Start selection | `v` |
| Copy selection | `y` (copies to clipboard via xclip) |
| Paste | `Prefix + P` |
| Quit copy mode | `q` or `Esc` |
| Scroll up | `Ctrl + u` |
| Scroll down | `Ctrl + d` |
| Search forward | `/` |
| Search backward | `?` |
| Next result | `n` |
| Prev result | `N` |

---

## ⚙️ Config

| Action | Key / Command |
|--------|---------------|
| Reload config | `Prefix + r` |
| Edit config | `nvim ~/.config/tmux/tmux.conf` |

---

## 💡 Misc

| Action | Key |
|--------|-----|
| Command prompt | `Prefix + :` |
| Show key bindings | `Prefix + ?` |
| Clock mode | `Prefix + t` |

---

## 🔁 Auto-start Tmux (zshrc)

Already added to `~/.zshrc`:

```shell
# Auto-start tmux if not already inside one
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
    exec tmux
fi
```
