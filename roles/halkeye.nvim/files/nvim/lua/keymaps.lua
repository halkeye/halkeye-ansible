-- vim.g.mapleader = [[ ]]
--
-- -- Next and previous
-- vim.keymap.set("n", "[b", ":bp<cr>")
-- vim.keymap.set("n", "]b", ":bn<cr>")
-- vim.keymap.set("n", "[t", ":tabp<cr>")
-- vim.keymap.set("n", "]t", ":tabn<cr>")
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '[q', ":cprev<cr>")
-- vim.keymap.set('n', ']q', ":cnext<cr>")
-- vim.keymap.set('n', '[l', ":lprev<cr>")
-- vim.keymap.set('n', ']l', ":lnext<cr>")
--
-- -- LSP
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('LspConfig', {}),
--   callback = function(ev)
--     local opts = { buffer = ev.buffer }
--     vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--     vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
--     vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
--     vim.keymap.set("n", "<C-f>", function() vim.lsp.buf.format({ async = true }) end, opts)
--   end
-- })
--
--
vim.keymap.set("n", "<Leader>te", ":tabedit<space>")
vim.keymap.set("n", "<Leader>tn", ":tabnew<space>")
vim.keymap.set("n", "<Leader>tm", ":tabmove<space>")

vim.keymap.set('n', '<Leader>la', function()
    require('telescope.builtin').lsp_references({
        preview_title = 'LSP References Preview',
        jump_type = 'split',
        fname_width = 50,
    })
end)

vim.keymap.set('n', '<Leader>ba', function()
    require('telescope.builtin').buffers({
        preview_title = 'Buffers',
    })
end)

vim.diagnostic.config({
  virtual_text = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
local bufopts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
vim.keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<cr>", bufopts)
vim.keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<cr>", bufopts)
vim.keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<cr>", bufopts)
vim.keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<cr>", bufopts)
vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, bufopts)
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, bufopts)
vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
-- show diagnostics in hover window
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "cursor",
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})
