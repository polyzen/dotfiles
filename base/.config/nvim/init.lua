vim.opt.guifont = 'Fantasque Sans Mono:h12'
vim.opt.history = 500
vim.opt.mouse = 'a' -- "Enables mouse support"
vim.opt.termguicolors = true -- "Enables 24-bit RGB color in the TUI"

-- Lines
vim.opt.showtabline = 2 -- Always show tab pages line
vim.opt.showmode = false -- Do not echo the mode, status line will display it
vim.opt.wildmenu = true -- Enable command-line completion menu
vim.opt.wildmode = 'longest:full,full' -- .. with incremental completions

-- Search
vim.opt.hlsearch = true -- Highlight matches
vim.opt.incsearch = true -- .. while typing
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- .. unless "pattern contains upper case characters"

-- Two-space indentation
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.cmd([[
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {}
  augroup END
]])

require('plugins')
require('lsp')
