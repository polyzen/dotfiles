-- Global mappings
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

local lspconfig = require('lspconfig')
local completion_capabilities = require('blink.cmp').get_lsp_capabilities()
local servers = { 'bashls', 'taplo', 'tailwindcss', 'typos_lsp' }
local servers_with_completions = { 'clangd', 'cssls', 'mesonlsp', 'svelte' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({})
end
for _, lsp in ipairs(servers_with_completions) do
  lspconfig[lsp].setup({ capabilities = completion_capabilities })
end

lspconfig.eslint.setup({
  filetypes = vim
    .iter({
      require('lspconfig.configs.eslint').default_config.filetypes,
      { 'html', 'json', 'yaml' },
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
  capabilities = completion_capabilities,
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
  capabilities = completion_capabilities,
  on_attach = function(client)
    client.server_capabilities.signatureHelpProvider = false
  end,
})

if vim.fn.executable('vscode-json-languageserver') == 1 then
  lspconfig.jsonls.setup({
    init_options = {
      provideFormatter = false,
    },
    capabilities = completion_capabilities,
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  })
end

lspconfig.pyright.setup({
  on_attach = function(client)
    client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
  end,
})

lspconfig.ruff.setup({
  init_options = {
    settings = {
      organizeImports = false,
      fixAll = false,
    },
  },
})

lspconfig.lua_ls.setup({
  capabilities = completion_capabilities,
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

lspconfig.ts_ls.setup({
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

lspconfig.volar.setup({
  capabilities = completion_capabilities,
  init_options = {
    typescript = {
      tsdk = '/usr/lib/node_modules/typescript/lib',
    },
  },
})

if vim.fn.executable('yaml-language-server') == 1 then
  lspconfig.yamlls.setup({
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        customTags = { '!reference sequence' },
        format = { enable = false },
        schemas = require('schemastore').yaml.schemas(),
        schemaStore = {
          enable = false,
          url = '',
        },
      },
    },
  })
end
