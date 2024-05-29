require("lazy").setup({
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "duane9/nvim-rg",
  "tpope/vim-surround",
  "tpope/vim-commentary",
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
--  {
--    "folke/tokyonight.nvim",
--    lazy = false,
--    priority = 1000,
--    opts = { style = "night" },
--    init = function()
--      vim.cmd.colorscheme("tokyonight")
--    end,
--  },
  {
    "NLKNguyen/papercolor-theme",
    lazy = false,
    init = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme("PaperColor")
    end,
  },
  "github/copilot.vim",
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
      vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
      vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
      vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
      vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
      vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
    end,
  },
  { "nvimtools/none-ls.nvim" },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      vim.opt_global.omnifunc = 'v:lua.vim.lsp.omnifunc'

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local on_attach = function(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        vim.lsp.inlay_hint.enable()
      end

      mason_lspconfig.setup {
        ensure_installed = {
          "ansiblels",
          "bashls",
          "cssls",
          "dockerls",
          "ember",
          "eslint",
          "gopls",
          "graphql",
          "helm_ls",
          "html",
          "jsonls",
          "lua_ls",
          "marksman",
          "ruby_lsp",
          "ruff",
          "ruff_lsp",
          "rust_analyzer",
          "sqlls",
          "sqls",
          "tailwindcss",
          "tsserver",
          "typos_lsp",
          "yamlls",
        },
      }
      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
        ["gopls"] = function()
          lspconfig.gopls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
              gopls = {
                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  constantValues = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
              },
            },
          })
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    enabled = true,
    opts = { mode = "cursor" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "go", "gomod", "lua", "bash", "starlark", "rust" },
        highlight = {
          enable = true,
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local exists, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if exists and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V',  -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              --
              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
              ["]o"] = "@loop.*",
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
              --
              -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
              -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            }
          },
        },
      })
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "hrsh7th/cmp-path",
  },
  {
    "hrsh7th/cmp-cmdline",
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require'cmp'
      cmp.setup {
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        }, {
          { name = 'buffer' },
        })
      }
    end,
  },
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
})
