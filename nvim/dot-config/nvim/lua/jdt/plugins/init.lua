return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  {
    "catppuccin/nvim",
    name= "catppuccin",
    priority= 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        background = {
          light = "latte",
          dark = "frappe",
        },
        transparent_background = true,
      })
      -- load the scheme
      vim.cmd([[colorscheme catppuccin]])
    end,

  }, -- catppuccin theme
}
