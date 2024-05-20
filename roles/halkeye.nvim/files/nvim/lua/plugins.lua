require("lazy").setup({
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "tpope/vim-surround",
  "tpope/vim-commentary",
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end
  },
  require("plugins.ai"),
  require("plugins.colorscheme"),
  require("plugins.lsp"),
  require("plugins.nav"),
  require("plugins.telescope"),
  require("plugins.treesitter"),
})
