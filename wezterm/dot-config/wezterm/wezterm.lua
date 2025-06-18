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
	family = "Fira Code",
})
config.max_fps = 60
config.font_size = 16
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.8
config.window_decorations = "RESIZE"
config.macos_window_background_blur = 10
return config
