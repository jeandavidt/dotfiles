local wezterm = require("wezterm")
local config = {}
config.color_scheme = "Catppuccin Mocha"
config.window_padding = {
	left = "2cell",
	right = "2cell",
	top = "1cell",
	bottom = "1cell",
}
config.font = wezterm.font({
	family = "JetBrainsMono Nerd Font",
})

config.font_size = 15
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.7
config.window_decorations = "RESIZE"
config.macos_window_background_blur = 25
config.keys = {
	-- Remap left Alt + ç to produce a tilde (~)
	{
		key = "ç",
		mods = "ALT",
		action = wezterm.action.SendString("~"),
	},
}
config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}
return config
