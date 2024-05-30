vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.foldlevel = 20
vim.opt.list = true
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.relativenumber = false
vim.opt.scrolloff = 999
vim.opt.shell = "zsh"
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.wrap = false

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
