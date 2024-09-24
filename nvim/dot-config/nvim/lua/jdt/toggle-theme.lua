-- Function to check the macOS theme
local function get_macos_theme()
	local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
	local result = handle:read("*a")
	handle:close()
	return result:match("Dark") and "dark" or "light"
end

-- Apply the Catppuccin theme based on the macOS theme
local theme = get_macos_theme()
if theme == "dark" then
	vim.cmd([[colorscheme catppuccin-mocha]])
else
	vim.cmd([[colorscheme catppuccin-latte]])
end
