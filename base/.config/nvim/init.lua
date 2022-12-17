vim.o.termguicolors = true -- "Enables 24-bit RGB color in the TUI"

-- Lines
vim.o.showtabline = 2 -- Always show tab pages line
vim.o.showmode = false -- Do not echo the mode, status line will display it
vim.opt.wildmode:prepend({ 'longest:full' }) -- Incremental command-line completions

-- Search
vim.o.ignorecase = true -- Ignore case
vim.o.smartcase = true -- .. unless "pattern contains upper case characters"

-- Two-space indentation
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

vim.api.nvim_create_augroup('highlight_yank', {})
-- stylua: ignore
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'highlight_yank',
  pattern = '*',
  callback = function() vim.highlight.on_yank() end,
})

require('impatient')
require('plugins')
require('lsp')
