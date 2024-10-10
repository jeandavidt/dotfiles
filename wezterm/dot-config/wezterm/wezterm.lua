local wezterm = require("wezterm")
local config = {}

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Catppuccin Latte"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end
local function appearance_opacity(appearance)
	if appearance:find("Dark") then
		return 0.9
	else
		return 0.9
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.window_padding = {
	left = "2cell",
	right = "2cell",
	top = "1cell",
	bottom = "1cell",
}
config.font = wezterm.font({
	family = "JetBrainsMono Nerd Font",
	weight = "Thin",
})

config.font_size = 15
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = appearance_opacity(get_appearance())
config.window_decorations = "RESIZE"
return config
