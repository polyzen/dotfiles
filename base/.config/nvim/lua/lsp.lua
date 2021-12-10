local nvim_lsp = require('lspconfig')
nvim_lsp.util.default_config = vim.tbl_extend('force', nvim_lsp.util.default_config, {
  flags = {
    debounce_text_changes = 150,
  },
})

local lsp_status = require('lsp-status')
lsp_status.config({
  current_function = false,
  diagnostics = false,
  status_symbol = '',
})
lsp_status.register_progress()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require('lsp_signature').on_attach()
  lsp_status.on_attach(client)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('v', '<space>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end
end

local null_ls = require('null-ls')
local sources = {
  null_ls.builtins.code_actions.eslint,
  null_ls.builtins.code_actions.shellcheck.with({
    filetypes = { 'PKGBUILD', 'sh' },
  }),
  null_ls.builtins.diagnostics.eslint,
  null_ls.builtins.diagnostics.flake8,
  null_ls.builtins.diagnostics.selene.with({
    cwd = function(params)
      local conf_file = vim.fn.findfile('selene.toml', params.root)
      if conf_file then
        return vim.fn.fnamemodify(conf_file, ':p:h')
      end
    end,
  }),
  null_ls.builtins.diagnostics.shellcheck.with({
    extra_args = function(params)
      return params.ft == 'PKGBUILD' and { '--exclude', 'SC2148,SC2034,SC2154,SC2155,SC2164' } or {}
    end,
    filetypes = { 'PKGBUILD', 'sh' },
  }),
  null_ls.builtins.diagnostics.stylelint,
  null_ls.builtins.diagnostics.vint,
  null_ls.builtins.diagnostics.yamllint,
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.formatting.json_tool,
  null_ls.builtins.formatting.prettier,
  null_ls.builtins.formatting.rustfmt,
  null_ls.builtins.formatting.shfmt.with({
    filetypes = { 'PKGBUILD', 'sh' },
  }),
  null_ls.builtins.formatting.stylua,
}
null_ls.config({ sources = sources })

local servers = { 'bashls', 'null-ls', 'pyright', 'tailwindcss', 'taplo', 'yamlls' }
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

local servers_with_snippets = { 'cssls', 'gopls', 'html', 'jsonls' }
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

nvim_lsp.sumneko_lua.setup({
  capabilities = capabilities,
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
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
