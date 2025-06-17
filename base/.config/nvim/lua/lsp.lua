vim.diagnostic.config({ virtual_lines = true })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    ---@cast client -nil

    -- Buffer-local mappings
    local opts = { buffer = bufnr }
    if client:supports_method('textDocument/declaration') then
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    end
    if client:supports_method('textDocument/signatureHelp') then
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    end
    if client:supports_method('workspace/didChangeWorkspaceFolders') then
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    end
    if client:supports_method('workspace/workspaceFolders') then
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
    end
    if client:supports_method('textDocument/typeDefinition') then
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    end

    -- Buffer-local features
    if client:supports_method('textDocument/documentHighlight') then
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

    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
})

vim.lsp.enable({
  'bashls',
  'clangd',
  'cssls',
  'esbonio',
  'eslint',
  'gitlab_ci_ls',
  'gopls',
  'html',
  'jedi_language_server',
  'jsonls',
  'lua_ls',
  'mesonlsp',
  'pyright',
  'ruff',
  'svelte',
  'tailwindcss',
  'taplo',
  'ts_ls',
  'typos_lsp',
  'vue_ls',
  'yamlls',
})

vim.lsp.config('esbonio', {
  init_options = {
    sphinx = {
      silent = 1,
    },
  },
})

vim.lsp.config('eslint', {
  filetypes = vim
    .iter({
      require('lspconfig.configs.eslint').default_config.filetypes,
      { 'html', 'json', 'yaml' },
    })
    :flatten()
    :totable(),
  settings = { run = 'onSave' },
})

vim.lsp.config('gopls', {
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

vim.lsp.config('html', {
  init_options = {
    provideFormatter = false,
  },
})

vim.lsp.config('jedi_language_server', {
  on_attach = function(client)
    client.server_capabilities.signatureHelpProvider = false
  end,
})

vim.lsp.config('jsonls', {
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      validate = { enable = true },
    },
  },
  before_init = function(_, config)
    config.settings.json.schemas = require('schemastore').json.schemas()
  end,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      format = { enable = false },
      hint = { enable = true },
      workspace = {
        checkThirdParty = 'Disable',
      },
    },
  },
})

vim.lsp.config('pyright', {
  on_attach = function(client)
    client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
  end,
})

vim.lsp.config('ruff', {
  init_options = {
    settings = {
      organizeImports = false,
      fixAll = false,
    },
  },
})

vim.lsp.config('ts_ls', {
  filetypes = vim
    .iter({
      require('lspconfig.configs.ts_ls').default_config.filetypes,
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

vim.lsp.config('vue_ls', {
  init_options = {
    typescript = {
      tsdk = '/usr/lib/node_modules/typescript/lib',
    },
  },
})

vim.lsp.config('yamlls', {
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      customTags = { '!reference sequence' },
      format = { enable = false },
      schemaStore = {
        enable = false,
        url = '',
      },
    },
  },
  before_init = function(_, config)
    config.settings.yaml.schemas = require('schemastore').yaml.schemas()
  end,
})
