return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			vim.opt.conceallevel = 1
			require("obsidian").setup({
				workspaces = {
					{
						name = "Obsidian Vault",
						path = "/Users/jeandavidt/Documents/Obsidian Vault/",
					},
				},
				notes_subdir = "_Inbox",
				new_notes_location = "notes_subdir",

				disable_frontmatter = false,
				templates = {
					subdir = "Templates",
					date_format = "%Y-%m-%d",
					time_format = "%H:%M:%S",
				},

				note_id_func = function(title)
					local suffix = ""
					-- get current iso datetime with -5 hour offset from utc for est
					local current_datetime = os.date("!%y-%m-%d-%h%m%s", os.time() - 5 * 3600)
					if title ~= nil then
						suffix = title:gsub(" ", "-"):gsub("[^a-za-z0-9-]", ""):lower()
					else
						for _ = 1, 4 do
							suffix = suffix .. string.char(math.random(65, 90))
						end
					end
					return current_datetime .. "_" .. suffix
				end,

				-- key mappings, below are the defaults
				mappings = {
					-- overrides the 'gf' mapping to work on markdown/wiki links within your vault
					["gf"] = {
						action = function()
							return require("obsidian").util.gf_passthrough()
						end,
						opts = { noremap = false, expr = true, buffer = true },
					},
					-- toggle check-boxes
					-- ["<leader>ch"] = {
					--   action = function()
					--     return require("obsidian").util.toggle_checkbox()
					--   end,
					--   opts = { buffer = true },
					-- },
				},
				completion = {
					nvim_cmp = true,
					min_chars = 2,
				},
			})
		end,
	},
}
