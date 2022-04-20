vim.opt.guifont = 'Fantasque Sans Mono:h12'
vim.opt.mouse = 'a' -- "Enables mouse support"
vim.opt.termguicolors = true -- "Enables 24-bit RGB color in the TUI"

-- Lines
vim.opt.showtabline = 2 -- Always show tab pages line
vim.opt.showmode = false -- Do not echo the mode, status line will display it
vim.opt.wildmode = 'longest:full,full' -- Incremental command-line completions

-- Search
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- .. unless "pattern contains upper case characters"

-- Two-space indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.api.nvim_create_augroup('highlight_yank', {})
-- stylua: ignore
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'highlight_yank',
  pattern = '*',
  callback = function() vim.highlight.on_yank() end,
})

require('plugins')
require('lsp')
