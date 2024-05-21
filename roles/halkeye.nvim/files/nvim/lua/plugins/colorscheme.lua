return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night" },
    init = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "NLKNguyen/papercolor-theme",
    lazy = false,
    init = function()
      vim.opt.background = "dark",
      vim.cmd.colorscheme("PaperColor")
    end,
  },
}
