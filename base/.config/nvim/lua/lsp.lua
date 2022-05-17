-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- stylua: ignore
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_create_augroup('lsp_document_highlight', {
      clear = false,
    })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = 'lsp_document_highlight',
    })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local null_ls = require('null-ls')
local sources = {
  null_ls.builtins.code_actions.eslint,
  null_ls.builtins.code_actions.eslint.with({
    filetypes = { 'html' },
    condition = function(utils)
      return utils.root_has_file({ 'node_modules' })
    end,
  }),
  null_ls.builtins.code_actions.shellcheck.with({
    extra_filetypes = { 'PKGBUILD' },
  }),
  null_ls.builtins.diagnostics.eslint,
  null_ls.builtins.diagnostics.eslint.with({
    filetypes = { 'html' },
    condition = function(utils)
      return utils.root_has_file({ 'node_modules' })
    end,
  }),
  null_ls.builtins.diagnostics.flake8,
  null_ls.builtins.diagnostics.rstcheck,
  null_ls.builtins.diagnostics.selene.with({
    cwd = function(params)
      local conf_file = vim.fn.findfile('selene.toml', params.root)
      if conf_file then
        return vim.fn.fnamemodify(conf_file, ':p:h')
      end
    end,
  }),
  null_ls.builtins.diagnostics.stylelint,
  null_ls.builtins.diagnostics.vint,
  null_ls.builtins.diagnostics.yamllint,
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.formatting.jq,
  null_ls.builtins.formatting.prettier,
  null_ls.builtins.formatting.rustfmt,
  null_ls.builtins.formatting.shfmt.with({
    extra_filetypes = { 'PKGBUILD' },
  }),
  null_ls.builtins.formatting.stylua,
}
null_ls.setup({
  sources = sources,
  on_attach = on_attach,
})

local nvim_lsp = require('lspconfig')
local servers = { 'bashls', 'pyright', 'tailwindcss', 'taplo', 'yamlls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({ on_attach = on_attach })
end

if vim.fn.executable('typescript-language-server') == 1 then
  nvim_lsp.tsserver.setup({
    -- Only needed for inlayHints
    init_options = require('nvim-lsp-ts-utils').init_options,
    on_attach = function(client, bufnr)
      -- Defer formatting to prettier via null-ls
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      local ts_utils = require('nvim-lsp-ts-utils')
      ts_utils.setup({})
      -- Required to fix code action ranges and filter diagnostics
      ts_utils.setup_client(client)

      on_attach(client, bufnr)
    end,
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local servers_with_snippets = { 'cssls', 'gopls', 'jsonls' }
for _, lsp in ipairs(servers_with_snippets) do
  nvim_lsp[lsp].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

nvim_lsp.ccls.setup({
  capabilities = capabilities,
  init_options = {
    highlight = {
      lsRanges = true,
    },
  },
  on_attach = on_attach,
})

nvim_lsp.html.setup({
  capabilities = capabilities,
  init_options = {
    provideFormatter = false,
  },
  on_attach = on_attach,
})

nvim_lsp.sumneko_lua.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
  on_attach = on_attach,
})

if vim.fn.executable('rust-analyzer') == 1 then
  require('rust-tools').setup({
    server = {
      capabilities = capabilities,
      on_attach = on_attach,
    },
  })
end

nvim_lsp.volar.setup({
  capabilities = capabilities,
  init_options = {
    typescript = {
      serverPath = '/usr/lib/node_modules/typescript/lib/tsserverlibrary.js',
    },
  },
  on_attach = on_attach,
})
