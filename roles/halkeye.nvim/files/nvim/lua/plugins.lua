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


require("lazy").setup({
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
        eruby = { "erb-lint" },
        python = { "isort", "black" },
        sh = { "shfmt" },
        go = { "gofmt", "goimports-reviser" },
        -- Use a sub-list to run only the first available formatter
        javascript = function(bufnr) return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint_d", "eslint") } end,
        javascriptreact = function(bufnr)
          return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint_d",
            "eslint") }
        end,
        tsserver = function(bufnr) return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint_d", "eslint") } end,
        typescript = function(bufnr) return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint_d", "eslint") } end,
        typescriptreact = function(bufnr)
          return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint_d",
            "eslint") }
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
      lint.linters_by_ft = {
        ruby = {
          "rubocop"
        },
        eruby = {
          "erb-lint"
        },
        javascript = {
          "eslint_d"
        },
        tsserver = {
          "eslint_d"
        },
        typescript = {
          "eslint_d"
        },
        javascriptreact = {
          "eslint_d"
        },
        typescriptreact = {
          "eslint_d"
        }
      }
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
        },
      }
    end,
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
        "<Leader>ff",
        function()
          require("telescope").extensions.vwd.find_files({})
        end,
        desc = "Files",
      },
      {
        "<Leader>fg",
        function()
          require("telescope").extensions.vwd.live_grep({ default_text = vim.fn.expand("<cword>") })
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
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night" },
    init = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme("tokyonight")
    end,
  },
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
            buildFlags = { "-tags=integration" }
          }
        }
      })
      vim.lsp.config("*", {
        capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
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
      })
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
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
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
        default = { 'lsp', 'path', 'snippets', 'buffer' },
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
})
