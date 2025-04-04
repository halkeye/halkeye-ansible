-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

wezterm.on('mux-startup', function()
  local tab, pane, window = mux.spawn_window {}
  pane:split { direction = 'Top' }
end)

-- This will hold the configuration.
local config = wezterm.config_builder()

-- dont mess with strings being pasted in
config.canonicalize_pasted_newlines = "None"

-- This is where you actually apply your config choices
config.default_domain = 'WSL:Ubuntu'
config.default_cwd = wezterm.home_dir

-- For example, changing the color scheme:
config.color_scheme = 'Dracula (Official)'
-- config.color_scheme = 'AdventureTime'

config.hide_tab_bar_if_only_one_tab = true

config.mouse_bindings = {
  -- There are mouse binding to mimc Windows Terminal and let you copy
  -- To copy just highlight something and right click. Simple
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
      end
    end),
  },
}

config.keys = {
  {
    key = 'V',
    mods = 'CTRL',
    action = act.PasteFrom 'Clipboard'
  },
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },
  {
    key = '"',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '%',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
}

-- and finally, return the configuration to wezterm
return config
