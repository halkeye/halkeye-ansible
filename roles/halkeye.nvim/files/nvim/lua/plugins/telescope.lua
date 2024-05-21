return {
  {
    "nvim-telescope/telescope-fzy-native.nvim",
  },
  {
    "kelly-lin/telescope-ag",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = { ".git/", "vendor/" },
          mappings = {
            i = {
              ["<CR>"] = function(bufnr)
                return require("telescope.actions.set").edit(bufnr, "tab drop")
              end,
              ["<C-j>"] = function(bufnr)
                return require("telescope.actions").move_selection_next(bufnr)
              end,
              ["<C-k>"] = function(bufnr)
                return require("telescope.actions").move_selection_previous(bufnr)
              end,
            },
          },
        },
        extensions = {
          fzy_native = {
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            hidden = true,
          },
        },
        keys = {
          {
            "<Leader>fr",
            function()
              require("telescope.builtin").resume()
            end,
            desc = "Resume previous picker",
          },
          {
            "<Leader>fb",
            function()
              require("telescope.builtin").buffers()
            end,
            desc = "Buffers",
          },
          {
            "<Leader>fh",
            function()
              require("telescope.builtin").help_tags()
            end,
            desc = "Help tags",
          },
          {
            "<Leader>ff",
            function()
              require("telescope").extensions.vwd.find_files({})
            end,
            desc = "Files",
          },
          {
            "<Leader>fg",
            function()
              require("telescope").extensions.vwd.live_grep({})
            end,
            desc = "Grep",
          },
          {
            "<Leader>fq",
            function()
              require("telescope.builtin").quickfix()
            end,
            desc = "Quickfixes",
          },
          {
            "<Leader>fk",
            function()
              require("telescope.builtin").keymaps()
            end,
            desc = "Keymaps",
          },
          {
            "<Leader>fs",
            function()
              require("telescope.builtin").git_status()
            end,
            desc = "Git Status",
          },
        },
      }
    end,
  },
}
