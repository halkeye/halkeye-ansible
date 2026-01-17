---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

vim.filetype.add({
  pattern = {
    [".*/.github/workflows/.*%.yml"] = "yaml.ghaction",
  },
})

require("lazy").setup({
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        "nvim-dap-ui",
      },
    },
  },
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "duane9/nvim-rg",
  "tpope/vim-surround",
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>rr",
        "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>rR",
        "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        ruby = { "rubocop" },
        eruby = { "erb_format" },
        python = { "isort", "black" },
        html = { "htmlbeautifier" },
        sh = { "shfmt" },
        go = { "gofmt", "goimports-reviser" },
        -- Use a sub-list to run only the first available formatter
        javascript = function(bufnr) return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint") } end,
        javascriptreact = function(bufnr)
          return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint") }
        end,
        tsserver = function(bufnr) return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint") } end,
        typescript = function(bufnr) return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint") } end,
        typescriptreact = function(bufnr)
          return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint") }
        end,
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        ["goimports-reviser"] = {
          prepend_args = { "-company-prefixes", "do/" }
        },
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      if vim.fn.executable("go") == 1 then
        local modpath = vim.fn.trim(vim.fn.system("go env GOMOD | xargs dirname"))
        if vim.v.shell_error ~= 1 then
          lint.linters.revive.cmd = "go"
          lint.linters.revive.args = {
            "tool",
            "revive",
            "-formatter",
            "json",
            "-config",
            modpath .. "/revive.toml",
          }
        end
      end
      lint.linters_by_ft = {
        go = {
          "revive"
        },
        ruby = {
          "rubocop"
        },
        eruby = {
          "erb_lint"
        },
        javascript = {
          "eslint"
        },
        tsserver = {
          "eslint"
        },
        typescript = {
          "eslint"
        },
        javascriptreact = {
          "eslint"
        },
        typescriptreact = {
          "eslint"
        },
        ["ghaction"] = {
          "actionlint"
        },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      opleader = { line = '<C-_>', block = 'gb' },
    },
    lazy = false
  },
  {
    "prichrd/vwd.nvim",
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
      require("telescope").setup {
        defaults = {
          layout_config = {
            vertical = { width = 0.5 }
          },
          file_ignore_patterns = { ".git/", "vendor/", "node_modules/", },
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
          diagnostics = {
            bufnr = 0,
            theme = "dropdown",
            prompt_title = "diagnostics",
            previewer = false
          }
        },
      }
    end,
    keys = {
      {
        "<Leader>be",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Buffers",
      },
      {
        "<Leader>la",
        function()
          require('telescope.builtin').lsp_references({
            preview_title = 'LSP References Preview',
            jump_type = 'split',
            fname_width = 50,
          })
        end,
        desc = "LSP References Preview",
      },
      {
        "<Leader>ba",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Buffers",
      },
      {
        "<c-P>",
        function()
          require("telescope").extensions.vwd.find_files(require('telescope.themes').get_dropdown({ winblend = 10 }))
        end,
        desc = "Files",
      },
      {
        "<Leader>qf",
        function()
          require("telescope.builtin").quickfix()
        end,
        desc = "Quickfixes",
      },
      {
        "<Leader>gs",
        function()
          require("telescope.builtin").git_status()
        end,
        desc = "Git Status",
      },
      {
        "<Leader>de",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Diagnostics",
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    init = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme('catppuccin-macchiato')
    end,
  },
  -- {
  --   "sainnhe/gruvbox-material",
  --   lazy = false,
  --   priority = 1000,
  --   init = function()
  --     vim.opt.background = "dark"
  --     vim.cmd.colorscheme('gruvbox-material')
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = { style = "night" },
  --   init = function()
  --     vim.opt.background = "dark"
  --     vim.cmd.colorscheme("tokyonight")
  --   end,
  -- },
  -- {
  --   "NLKNguyen/papercolor-theme",
  --   lazy = false,
  --   init = function()
  --     vim.opt.background = "dark"
  --     vim.cmd.colorscheme("PaperColor")
  --   end,
  -- },
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end
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
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "cssls",
        "dockerls",
        "eslint",
        "gopls",
        "graphql",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        -- "jedi_language_server", -- python
        "pylsp", -- python
        "ruby_lsp",
        "rust_analyzer",
        "tailwindcss",
        "ts_ls",
        "typos_lsp",
        "yamlls",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
          'shellcheck',
          'shfmt',
          'goimports-reviser',
          'golines',
          'prettierd',
          'eslint_d',
          'erb-lint',
          'erb-formatter',
        }
      }
    end,
  },
  {
    "folke/neoconf.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neoconf.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp"
    },
    config = function()
      vim.lsp.config('pylsp', {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = { 'W391' },
                maxLineLength = 100
              }
            }
          }
        },
      })

      vim.lsp.config('yamlls', {
        settings = {
          yaml = {
            format = { enable = false, singleQuote = true, printWidth = 120, },
            hover = true,
            completion = true,
            validate = true,
            schemaStore = { enable = true, url = "https://www.schemastore.org/json", },
          },
        },
      })
      vim.lsp.config('gopls', {
        before_init = function(_, config)
          if vim.fn.executable("go") ~= 1 then
            return
          end

          local module = vim.fn.trim(vim.fn.system("go list -m"))
          if vim.v.shell_error ~= 0 then
            return
          end
          module = module:gsub("\n", ",")

          config.settings.gopls["formatting.local"] = module
        end,
        settings = {
          gopls = {
            ["diagnostic.vulncheck"] = "Imports",
            buildFlags = { "-tags=integration,sandbox" }
          }
        }
      })
      vim.lsp.config("*", {
        -- capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
      })
    end,
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  --   event = "BufReadPre",
  --   enabled = true,
  --   opts = { mode = "cursor" },
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    -- dependencies = {
    --   "nvim-treesitter/nvim-treesitter-context",
    --   "nvim-treesitter/nvim-treesitter-textobjects",
    -- },
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    opts = {
      ensure_installed = {
        "bash",
        "diff",
        "dockerfile",
        "go",
        "gomod",
        "graphql",
        "html",
        "javascript",
        "json",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "ruby",
        "rust",
        "scss",
        "ssh_config",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      indent = {
        enable = true
      },
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
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
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
    },
    init = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, _)
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
  {
  "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/luasnippets/" })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    'saghen/blink.cmp',
    dependencies = { 
      'L3MON4D3/LuaSnip',
      'giuxtaposition/blink-cmp-copilot'
    },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = 'luasnip' },

      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'enter',
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback'
        },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        list = { selection = { preselect = false } },
        documentation = { auto_show = false }
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'copilot' },

        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        tag_options = '',          -- sets options sent to gomodifytags, i.e., json=omitempty
        test_runner = 'gotestsum', -- one of {`go`,  `dlv`, `ginkgo`, `gotestsum`}
        run_in_floaterm = true,    -- set to true to run in a float window. :GoTermClose closes the floatterm
        -- float term recommend if you use gotestsum ginkgo with terminal color
        trouble = true,            -- true: use trouble to open quickfix
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    dependencies = {
      "zbirenbaum/copilot.lua"
    }
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        -- The following line is needed to fix the background color
        -- Set it to the lualine section you want to use
        hl_group = "lualine_c_normal",
      })
      require('lualine').setup {
        sections = { lualine_c = {
          {
            symbols.get,
            cond = symbols.has,
          },
          'data',
          "require'lsp-status'.status()"
        } },
        extensions = { 'quickfix', 'fzf', 'lazy', 'mason', 'oil', 'trouble' },
      }
    end,
    --    opts = function(_, opts)
    --      local trouble = require("trouble")
    --      local symbols = trouble.statusline({
    --        mode = "lsp_document_symbols",
    --        groups = {},
    --        title = false,
    --        filter = { range = true },
    --        format = "{kind_icon}{symbol.name:Normal}",
    --        -- The following line is needed to fix the background color
    --        -- Set it to the lualine section you want to use
    --        hl_group = "lualine_c_normal",
    --      })
    --      table.insert(opts.sections.lualine_a, {
    --        symbols.get,
    --        cond = symbols.has,
    --      })
    --    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio"
    },
    lazy = true,
    -- Copied from LazyVim/lua/lazyvim/plugins/extras/dap/core.lua and
    -- modified.
    keys = {
      {
        "<leader>db",
        function() require("dap").toggle_breakpoint() end,
        desc = "Toggle Breakpoint"
      },

      {
        "<leader>dc",
        function() require("dap").continue() end,
        desc = "Continue"
      },

      {
        "<leader>dC",
        function() require("dap").run_to_cursor() end,
        desc = "Run to Cursor"
      },

      {
        "<leader>dT",
        function() require("dap").terminate() end,
        desc = "Terminate"
      },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "[D]ap [U]I"
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "[D]ap [E]val"
      },
    },
    config = function(_, opts)
      local dap, dapui = require 'dap', require 'dapui'
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      dapui.setup(opts)
    end,
  },
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function(_, _)
      require('dap-go').setup {
        -- Additional dap configurations can be added.
        -- dap_configurations accepts a list of tables where each entry
        -- represents a dap configuration. For more details do:
        -- :help dap-configuration
        dap_configurations = {
          {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote",
            mode = "remote",
            port = 4444,
            host = "127.0.0.1",
            request = "attach",
          },
        },
      }
    end,
  },
  {
    'mrjones2014/op.nvim',
    build = "make install",
    opts = {
      -- you can change this to a full path if `op`
      -- is not on your $PATH
      op_cli_path = 'op',
      -- Whether to sign in on start.
      signin_on_start = false,
      -- show NerdFont icons in `vim.ui.select()` interfaces,
      -- set to false if you do not use a NerdFont or just
      -- don't want icons
      use_icons = true,
      -- settings for op.nvim sidebar
      sidebar = {
        -- sections to include in the sidebar
        sections = {
          favorites = true,
          secure_notes = true,
        },
        -- sidebar width
        width = 40,
        -- put the sidebar on the right or left side
        side = 'right',
        -- keymappings for the sidebar buffer.
        -- can be a string mapping to a function from
        -- the module `op.sidebar.actions`,
        -- an editor command string, or a function.
        -- if you supply a function, a table with the following
        -- fields will be passed as an argument:
        -- {
        --   title: string,
        --   icon: string,
        --   type: 'header' | 'item'
        --   -- data will be nil if type == 'header'
        --   data: nil | {
        --       uuid: string,
        --       vault_uuid: string,
        --       category: string,
        --       url: string
        --     }
        -- }
        mappings = {
          -- if it's a Secure Note, open in op.nvim's Secure Notes editor;
          -- if it's an item with a URL, open & fill the item in default browser;
          -- otherwise, open in 1Password 8 desktop app
          ['<CR>'] = 'default_open',
          -- open in 1Password 8 desktop app
          ['go'] = 'open_in_desktop_app',
          -- edit in 1Password 8 desktop app
          ['ge'] = 'edit_in_desktop_app',
        },
      },
      -- Custom formatter function for statusline component
      statusline_fmt = function(account_name)
        if not account_name or #account_name == 0 then
          return ' 1Password: No active session'
        end

        return string.format(' 1Password: %s', account_name)
      end,
      -- global_args accepts any arguments
      -- listed under "Global Flags" in
      -- `op --help` output.
      global_args = {
        -- use the item cache
        '--cache',
        -- print output with no color, since we
        -- aren't viewing the output directly anyway
        '--no-color',
      },
      -- Use biometric unlock by default,
      -- set this to false and also see
      -- "Using Token-Based Sessions" section
      -- of README.md if you don't use biometric
      -- unlock for CLI.
      biometric_unlock = true,
      -- settings for Secure Notes editor
      secure_notes = {
        -- prefix for buffer names when
        -- editing 1Password Secure Notes
        buf_name_prefix = '1P:',
      },
      -- configuration for automatic secret detection
      -- it can also be triggered manually with `:OpAnalyzeBuffer`
      secret_detection_diagnostics = {
        -- disable the feature if set to true
        disabled = false,
        -- severity of produced diagnostics
        severity = vim.diagnostic.severity.WARN,
        -- disable on files longer than this
        max_file_lines = 10000,
        -- disable on these filetypes
        disabled_filetypes = {
          'nofile',
          'TelescopePrompt',
          'NvimTree',
          'Trouble',
          '1PasswordSidebar',
        },
      }
    },
  }
})
