return {
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, bufnr)
          return name == ".."
        end,
      },
      keymaps = {
        ["<TAB>"] = function()
          local oil = require('oil')
          require('vwd').set_vwd(oil.get_current_dir(), true)
          print("[oil] current vwd:", require('vwd').get_vwd())
        end,
      },
    },
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
      }
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<Leader>ha",
        function()
          local harpoon = require("harpoon")
          harpoon:list():add()
        end,
        desc = "Add a harpoon",
      },
      {
        "<Leader>hh",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Add a harpoon",
      },
      {
        "]h",
        function()
          local harpoon = require("harpoon")
          harpoon:list():next()
        end,
        desc = "Next harpoon",
      },
      {
        "[h",
        function()
          local harpoon = require("harpoon")
          harpoon:list():prev()
        end,
        desc = "Next harpoon",
      },
    },
  },

}
