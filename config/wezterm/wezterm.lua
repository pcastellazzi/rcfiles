--[[
macos_quit_when_last_window_closed yes
remember_window_size yes
scrollback_lines 1000
update_check_interval 0

tab_bar_edge top
tab_bar_min_tabs 0
tab_bar_style powerline
tab_title_template "{index}: {title}"

map cmd+1 goto_tab 1
map cmd+2 goto_tab 2
map cmd+3 goto_tab 3
map cmd+4 goto_tab 4
map cmd+5 goto_tab 5
map cmd+7 goto_tab 6
map cmd+7 goto_tab 7
map cmd+8 goto_tab 8
map cmd+9 goto_tab 9
map cmd+0 goto_tab 0
]]

local wezterm = require 'wezterm'

function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Light'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Selenized Dark (Gogh)'
  else
    return 'Selenized Light (Gogh)'
  end
end

local config = wezterm.config_builder()
local mux = wezterm.mux

wezterm.on('gui-attached', function(domain)
  for _, window in ipairs(mux.all_windows()) do
    window:gui_window():maximize()
  end
end)

config.audible_bell = "Disabled"
config.color_scheme = scheme_for_appearance(get_appearance())
config.font = wezterm.font "Fira Code"
config.font_size = 18
config.initial_cols = 150
config.initial_rows = 45
config.native_macos_fullscreen_mode = true
config.window_close_confirmation = "NeverPrompt"

return config
