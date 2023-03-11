-- Diagnostic mappings
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local capabilities = client.server_capabilities

    -- LSP mappings
    local lsp_formatting = function()
      vim.lsp.buf.format({
        timeout_ms = 2000,
        bufnr = bufnr,
        filter = function()
          return client.name ~= 'lua_ls' or 'tsserver'
        end,
      })
    end

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    if capabilities.hoverProvider and client.name ~= 'null-ls' then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    end
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', lsp_formatting, bufopts)

    -- Capabilities checks
    if capabilities.colorProvider then
      require('document-color').buf_attach(bufnr)
    end

    if capabilities.documentHighlightProvider then
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

    if capabilities.signatureHelpProvider then
      require('lsp_signature').on_attach()
    end
  end,
})

vim.api.nvim_create_augroup('LspAttach_inlayhints', {})
vim.api.nvim_create_autocmd('LspAttach', {
  group = 'LspAttach_inlayhints',
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require('lsp-inlayhints').on_attach(client, bufnr)
  end,
})

local null_ls = require('null-ls')
local sources = {
  null_ls.builtins.code_actions.eslint.with({
    prefer_local = 'node_modules/.bin',
  }),
  null_ls.builtins.code_actions.eslint.with({
    filetypes = { 'html', 'svelte' },
    only_local = 'node_modules/.bin',
  }),
  null_ls.builtins.code_actions.shellcheck.with({
    extra_filetypes = { 'PKGBUILD' },
  }),
  null_ls.builtins.diagnostics.eslint.with({
    prefer_local = 'node_modules/.bin',
  }),
  null_ls.builtins.diagnostics.eslint.with({
    filetypes = { 'html', 'svelte' },
    only_local = 'node_modules/.bin',
  }),
  null_ls.builtins.diagnostics.rstcheck,
  null_ls.builtins.diagnostics.selene.with({
    cwd = function(params)
      local conf_file = vim.fn.findfile('selene.toml', params.root)
      if conf_file then
        return vim.fn.fnamemodify(conf_file, ':p:h')
      end
    end,
  }),
  null_ls.builtins.diagnostics.stylelint.with({
    prefer_local = 'node_modules/.bin',
  }),
  null_ls.builtins.diagnostics.vint,
  null_ls.builtins.diagnostics.yamllint,
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.prettier.with({
    prefer_local = 'node_modules/.bin',
  }),
  null_ls.builtins.formatting.rustfmt,
  null_ls.builtins.formatting.shfmt.with({
    extra_filetypes = { 'PKGBUILD' },
  }),
  null_ls.builtins.formatting.stylua,
}
null_ls.setup({ sources = sources })

if vim.fn.executable('lua-language-server') == 1 then
  require('neodev').setup()
end

local nvim_lsp = require('lspconfig')
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { 'bashls', 'pyright', 'taplo', 'tailwindcss', 'yamlls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({})
end

if vim.fn.executable('clangd') == 1 then
  require('clangd_extensions').setup({
    server = { capabilities = cmp_capabilities },
    extensions = {
      autoSetHints = false,
    },
  })
end

nvim_lsp.cssls.setup({ capabilities = cmp_capabilities })

nvim_lsp.esbonio.setup({
  init_options = {
    sphinx = {
      silent = 1,
    },
  },
})

nvim_lsp.gopls.setup({
  capabilities = cmp_capabilities,
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

nvim_lsp.html.setup({
  init_options = {
    provideFormatter = false,
  },
})

nvim_lsp.jsonls.setup({
  capabilities = cmp_capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

nvim_lsp.ruff_lsp.setup({
  init_options = {
    settings = {
      organizeImports = false,
      fixAll = false,
    },
  },
})

if vim.fn.executable('rust-analyzer') == 1 then
  require('rust-tools').setup({
    server = { capabilities = cmp_capabilities },
    tools = {
      inlay_hints = {
        auto = false,
      },
    },
  })
end

nvim_lsp.lua_ls.setup({ capabilities = cmp_capabilities })

nvim_lsp.svelte.setup({ capabilities = cmp_capabilities })

if vim.fn.executable('typescript-language-server') == 1 then
  require('typescript').setup({
    server = {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    },
  })
end

nvim_lsp.volar.setup({
  capabilities = cmp_capabilities,
  init_options = {
    typescript = {
      tsdk = '/usr/lib/node_modules/typescript/lib',
    },
  },
})
