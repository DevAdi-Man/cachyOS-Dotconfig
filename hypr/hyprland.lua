-- ══════════════════════════════════════════════════════════════════════════════
--                    HYPRLAND CONFIGURATION ENTRY POINT
-- ══════════════════════════════════════════════════════════════════════════════

-- ─── Programs (used in keybinds) ─────────────────────────────────────────────
TERMINAL     = "kitty"
FILE_MANAGER = "thunar"
BROWSER      = "zen-browser"
MENU         = "rofi -show drun -show-icons"

-- ─── Fix module path so require() finds files relative to this config ─────────
local config_dir = os.getenv("HOME") .. "/.config/hypr"
package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path

-- ─── Modules ─────────────────────────────────────────────────────────────────
require("lua/display")
require("lua/autostart")
require("lua/keybinds")
require("lua/windowrules")
