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
	family = "Iosevka Term",
	--family = "Maple Mono",
	weight = "Light",
})
config.max_fps = 120
config.font_size = 15
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.macos_window_background_blur = 25
config.keys = {
	-- Remap left Alt + ç to produce a tilde (~)
	{
		key = "ç",
		mods = "ALT",
		action = wezterm.action.SendString("~"),
	},
	{
		key = ",",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "/opt/homebrew/bin/nvim", wezterm.config_dir .. "/wezterm.lua" },
		}),
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

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

return config
