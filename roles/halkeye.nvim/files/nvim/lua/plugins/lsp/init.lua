return {
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

      local lsp_utils = require("plugins.lsp.lsp-utils")
      lsp_utils.setup()

      vim.opt_global.omnifunc = 'v:lua.vim.lsp.omnifunc'

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
            on_attach = lsp_utils.on_attach,
            capabilities = lsp_utils.capabilities,
          })
        end,
        ["gopls"] = function()
          lspconfig.gopls.setup({
            on_attach = lsp_utils.on_attach,
            capabilities = lsp_utils.capabilities,
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
}
