-- ══════════════════════════════════════════════════════════════════════════════
--                         KEYBINDINGS
-- ══════════════════════════════════════════════════════════════════════════════

local mod = "SUPER"

-- ─── Apps ────────────────────────────────────────────────────────────────────
local app_binds = {
   { "Return", TERMINAL }, { "T", TERMINAL },
   { "M",      MENU }, { "B", BROWSER },
   { "E",      FILE_MANAGER },
   { "V",      "copyq toggle" },
   { "L",      "hyprlock --immediate-render --no-fade-in" },
   { "escape", "killall wlogout || wlogout" },
   { "I",      "networkmanager_dmenu" },
   { "Z",      "zeditor" },
   { "W",      "qs-barctl ipc bar toggleVisibility" },
   { "F1",     "~/.local/bin/wallpaper-change.sh" },
}
for _, b in ipairs(app_binds) do
   hl.bind(mod .. " + " .. b[1], hl.dsp.exec_cmd(b[2]))
end

-- ─── Window Management ───────────────────────────────────────────────────────
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + D", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + G", hl.dsp.layout("togglesplit"))  -- toggle horizontal/vertical split

-- ─── Arrow Binds (focus / move / resize) ─────────────────────────────────────
local dirs = { left = "l", right = "r", up = "u", down = "d" }
local resize_delta = { left = { -30, 0 }, right = { 30, 0 }, up = { 0, -30 }, down = { 0, 30 } }

for arrow, dir in pairs(dirs) do
   hl.bind(mod .. " + " .. arrow, hl.dsp.focus({ direction = dir }))
   hl.bind(mod .. " + SHIFT + " .. arrow, hl.dsp.window.move({ direction = dir }))
   local d = resize_delta[arrow]
   hl.bind(mod .. " + CTRL + " .. arrow, hl.dsp.window.resize({ x = d[1], y = d[2], relative = true }))
end

-- ─── Vim-style hjkl (focus / move / resize) ──────────────────────────────────
local hjkl = { h = "l", l = "r", k = "u", j = "d" }
local hjkl_resize = { h = { -30, 0 }, l = { 30, 0 }, k = { 0, -30 }, j = { 0, 30 } }

for key, dir in pairs(hjkl) do
   hl.bind(mod .. " + " .. key,              hl.dsp.focus({ direction = dir }))
   hl.bind(mod .. " + SHIFT + " .. key,      hl.dsp.window.move({ direction = dir }))
   local d = hjkl_resize[key]
   hl.bind(mod .. " + CTRL + " .. key,       hl.dsp.window.resize({ x = d[1], y = d[2], relative = true }))
end

-- ─── Workspaces ──────────────────────────────────────────────────────────────
for i = 1, 10 do
   local key = i % 10
   hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
   hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Cycle
hl.bind(mod .. " + Tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("CTRL + ALT + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + SUPER + ALT + right", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("CTRL + SUPER + ALT + left", hl.dsp.window.move({ workspace = "e-1" }))

-- Special workspace
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- ─── App Switcher ────────────────────────────────────────────────────────────
hl.bind("ALT + Tab", hl.dsp.exec_cmd(
   "rofi -show window -show-icons -icon-theme Papirus -theme ~/.config/rofi/window.rasi"
))

-- ─── Mouse ───────────────────────────────────────────────────────────────────
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ─── Screenshots ─────────────────────────────────────────────────────────────
-- Super+P         : region select → swappy (annotate → save + clipboard)
-- Super+ALT+P     : fullscreen → swappy
-- Super+SHIFT+P   : active window → swappy
-- Super+CTRL+P    : region select → seedha clipboard (swappy nahi)
hl.bind(mod .. " + p",         hl.dsp.exec_cmd('bash -c \'grim -g "$(slurp)" /tmp/shot.png && swappy -f /tmp/shot.png\''))
hl.bind(mod .. " + ALT + p",   hl.dsp.exec_cmd("bash -c 'grim /tmp/shot.png && swappy -f /tmp/shot.png'"))
hl.bind(mod .. " + SHIFT + p", hl.dsp.exec_cmd("bash -c 'hyprshot -m window -o /tmp -f shot.png && swappy -f /tmp/shot.png'"))
hl.bind(mod .. " + CTRL + p",  hl.dsp.exec_cmd('bash -c \'grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Clipboard mein copy ho gaya!"\''))

-- ─── Screen Recording ────────────────────────────────────────────────────────
local rec_stop  = 'killall -q wf-recorder && notify-send "Recording stopped" || '
local rec_file  = '-f ~/Videos/Screencasts/recording_$(date +%Y%m%d_%H%M%S).mp4'
local rec_start = 'notify-send "Recording started"'
hl.bind(mod .. " + F9",
   hl.dsp.exec_cmd(rec_stop .. '(wf-recorder -g "$(slurp)" ' .. rec_file .. ' & ' .. rec_start .. ')'))
hl.bind(mod .. " + F10",
   hl.dsp.exec_cmd(rec_stop .. '(wf-recorder ' .. rec_file .. ' & ' .. rec_start .. ')'))

-- ─── Volume ──────────────────────────────────────────────────────────────────
local vol_binds = {
   { "XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { locked = true, repeating = true } },
   { "XF86AudioLowerVolume", "bash " .. os.getenv("HOME") .. "/.config/hypr/scripts/volume-down.sh", { locked = true, repeating = true } },
   { "XF86AudioMute",        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",     { locked = true, repeating = true } },
   { "XF86AudioMicMute",     "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",   { locked = true, repeating = true } },
   { "CTRL + M",             "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",   {} },
}
for _, b in ipairs(vol_binds) do hl.bind(b[1], hl.dsp.exec_cmd(b[2]), b[3]) end

-- ─── Brightness ──────────────────────────────────────────────────────────────
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- ─── Media ───────────────────────────────────────────────────────────────────
local media_binds = {
   { "XF86AudioNext",  "playerctl next" },
   { "XF86AudioPause", "playerctl play-pause" },
   { "XF86AudioPlay",  "playerctl play-pause" },
   { "XF86AudioPrev",  "playerctl previous" },
   { "ALT + F1",       "playerctl previous" },
   { "ALT + F2",       "playerctl play-pause" },
   { "ALT + F3",       "playerctl next" },
}
for _, b in ipairs(media_binds) do hl.bind(b[1], hl.dsp.exec_cmd(b[2]), { locked = true }) end
