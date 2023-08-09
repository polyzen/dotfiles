-- Global mappings
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local capabilities = client.server_capabilities

    -- Buffer local mappings
    local lsp_formatting = function()
      local opts = { timeout_ms = 2000, bufnr = bufnr }
      local tsserver_filetypes = require('lspconfig.server_configurations.tsserver').default_config.filetypes
      -- Override tsserver formatter
      if vim.fn.index(tsserver_filetypes, vim.o.filetype) ~= -1 then
        vim.lsp.buf.format(vim.tbl_flatten({ name = 'null-ls', opts }))
      else
        vim.lsp.buf.format(opts)
      end
    end

    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    if capabilities.hoverProvider and client.name ~= 'null-ls' then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    end
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', lsp_formatting, opts)

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
  null_ls.builtins.diagnostics.markdownlint_cli2,
  null_ls.builtins.diagnostics.rstcheck,
  null_ls.builtins.diagnostics.selene,
  null_ls.builtins.diagnostics.stylelint.with({
    prefer_local = 'node_modules/.bin',
  }),
  null_ls.builtins.diagnostics.vint,
  null_ls.builtins.diagnostics.yamllint.with({
    condition = function(utils)
      if utils.root_has_file({ 'node_modules/.bin' }) then
        return false
      else
        return true
      end
    end,
  }),
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.mdformat,
  null_ls.builtins.formatting.prettier.with({
    prefer_local = 'node_modules/.bin',
  }),
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
local servers = { 'bashls', 'pyright', 'taplo', 'tailwindcss' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({})
end

nvim_lsp.clangd.setup({ capabilities = cmp_capabilities })

nvim_lsp.cssls.setup({ capabilities = cmp_capabilities })

nvim_lsp.eslint.setup({
  filetypes = vim.tbl_flatten({
    require('lspconfig.server_configurations.eslint').default_config.filetypes,
    { 'html', 'yaml' },
  }),
  settings = { run = 'onSave' },
})

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
  init_options = {
    provideFormatter = false,
  },
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

nvim_lsp.lua_ls.setup({
  capabilities = cmp_capabilities,
  settings = {
    Lua = {
      format = { enable = false },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})

nvim_lsp.svelte.setup({ capabilities = cmp_capabilities })

if vim.fn.executable('typescript-language-server') == 1 then
  require('typescript').setup({
    server = {
      init_options = {
        hostInfo = 'neovim',
        plugins = { { name = 'typescript-svelte-plugin', location = '/usr/lib/node_modules/typescript-svelte-plugin' } },
      },
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
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
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
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

nvim_lsp.yamlls.setup({
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      format = { enable = false },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
})
