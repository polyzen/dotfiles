-- Global mappings
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Buffer local mappings
    local lsp_formatting = function()
      local opts = { timeout_ms = 2000, bufnr = bufnr }
      local tsserver_filetypes = require('lspconfig.server_configurations.tsserver').default_config.filetypes
      -- Override tsserver formatter
      if vim.fn.index(tsserver_filetypes, vim.o.filetype) ~= -1 then
        vim.lsp.buf.format(vim.iter({ name = 'null-ls', opts }):flatten():totable())
      else
        vim.lsp.buf.format(opts)
      end
    end

    local opts = { buffer = bufnr }
    if client.supports_method('textDocument/declaration') then
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    end
    if client.supports_method('textDocument/implementation') then
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    end
    if client.supports_method('textDocument/signatureHelp') then
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    end
    if client.supports_method('workspace/didChangeWorkspaceFolders') then
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    end
    if client.supports_method('workspace/workspaceFolders') then
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
    end
    if client.supports_method('textDocument/typeDefinition') then
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    end
    if client.supports_method('textDocument/rename') then
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    end
    if client.supports_method('textDocument/codeAction') then
      vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    end
    if client.supports_method('textDocument/references') then
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    end
    if client.supports_method('textDocument/formatting') then
      vim.keymap.set('n', '<space>f', lsp_formatting, opts)
    end

    -- Buffer-local features
    if client.supports_method('textDocument/documentHighlight') then
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

    if client.supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client.supports_method('textDocument/signatureHelp') then
      require('lsp_signature').on_attach()
    end
  end,
})

local null_ls = require('null-ls')
local sources = {
  null_ls.builtins.diagnostics.markdownlint_cli2,
  null_ls.builtins.diagnostics.rstcheck,
  null_ls.builtins.diagnostics.selene,
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
  null_ls.builtins.formatting.mdformat,
  null_ls.builtins.formatting.prettier.with({
    prefer_local = 'node_modules/.bin',
  }),
  null_ls.builtins.formatting.stylua,
}
null_ls.setup({ sources = sources })

local lspconfig = require('lspconfig')
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { 'bashls', 'stylelint_lsp', 'taplo', 'tailwindcss' }
local servers_with_completions = { 'clangd', 'cssls', 'mesonlsp', 'svelte' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({})
end
for _, lsp in ipairs(servers_with_completions) do
  lspconfig[lsp].setup({ capabilities = cmp_capabilities })
end

lspconfig.eslint.setup({
  filetypes = vim
    .iter({
      require('lspconfig.server_configurations.eslint').default_config.filetypes,
      { 'html', 'yaml' },
    })
    :flatten()
    :totable(),
  settings = { run = 'onSave' },
})

lspconfig.esbonio.setup({
  init_options = {
    sphinx = {
      silent = 1,
    },
  },
})

lspconfig.gopls.setup({
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

lspconfig.html.setup({
  init_options = {
    provideFormatter = false,
  },
})

lspconfig.jedi_language_server.setup({
  capabilities = cmp_capabilities,
  on_attach = function(client)
    client.server_capabilities.signatureHelpProvider = false
  end,
})

lspconfig.jsonls.setup({
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

lspconfig.pyright.setup({
  on_attach = function(client)
    client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
  end,
})

lspconfig.ruff_lsp.setup({
  init_options = {
    settings = {
      organizeImports = false,
      fixAll = false,
    },
  },
})

lspconfig.lua_ls.setup({
  capabilities = cmp_capabilities,
  settings = {
    Lua = {
      format = { enable = false },
      workspace = {
        checkThirdParty = 'Disable',
      },
    },
  },
})

if vim.fn.executable('typescript-language-server') == 1 then
  lspconfig.tsserver.setup({
    filetypes = vim
      .iter({
        require('lspconfig.server_configurations.tsserver').default_config.filetypes,
        { 'vue' },
      })
      :flatten()
      :totable(),
    init_options = {
      hostInfo = 'neovim',
      plugins = {
        { name = 'typescript-svelte-plugin', location = '/usr/lib/node_modules/typescript-svelte-plugin' },
        {
          name = '@vue/typescript-plugin',
          location = '/usr/lib/node_modules/@vue/typescript-plugin',
          languages = { 'javascript', 'typescript', 'vue' },
        },
      },
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
  })
end

lspconfig.volar.setup({
  capabilities = cmp_capabilities,
  init_options = {
    typescript = {
      tsdk = '/usr/lib/node_modules/typescript/lib',
    },
  },
})

lspconfig.yamlls.setup({
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      format = { enable = false },
      schemas = require('schemastore').yaml.schemas(),
      schemaStore = {
        enable = false,
        url = '',
      },
    },
  },
})
