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

vim.o.foldenable = false

vim.diagnostic.config({
  virtual_lines = true,
  jump = { severity = { min = vim.diagnostic.severity.WARN } },
})
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_augroup('highlight_yank', {})
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'highlight_yank',
  desc = 'Briefly highlight yanked text',
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.filetype.add({
  filename = {
    ['.gitlab-ci.yml'] = 'yaml.gitlab',
  },
})

require('plugins')
