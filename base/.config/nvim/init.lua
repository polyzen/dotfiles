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
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'highlight_yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_augroup('pkgbuild_unfold', {})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = 'pkgbuild_unfold',
  pattern = 'PKGBUILD',
  callback = function()
    vim.o.foldenable = false
  end,
})

require('plugins')
require('lsp')
