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
        bufnr = bufnr,
        filter = function()
          return client.name ~= 'sumneko_lua' or 'tsserver'
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
null_ls.setup({ sources = sources })

local nvim_lsp = require('lspconfig')
local servers = { 'bashls', 'pyright', 'taplo', 'yamlls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({})
end

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities_with_color = capabilities
capabilities_with_color.textDocument.colorProvider = {
  dynamicRegistration = true,
}
local capabilities_with_snippets = require('cmp_nvim_lsp').update_capabilities(capabilities)
local capabilities_with_color_and_snippets = capabilities_with_snippets
capabilities_with_color_and_snippets.textDocument.colorProvider = {
  dynamicRegistration = true,
}

nvim_lsp.ccls.setup({
  capabilities = capabilities_with_snippets,
  init_options = {
    highlight = {
      lsRanges = true,
    },
  },
})

nvim_lsp.cssls.setup({ capabilities = capabilities_with_color_and_snippets })

nvim_lsp.gopls.setup({
  capabilities = capabilities_with_snippets,
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
  capabilities = capabilities,
  init_options = {
    provideFormatter = false,
  },
})

nvim_lsp.jsonls.setup({
  capabilities = capabilities_with_snippets,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

if vim.fn.executable('rust-analyzer') == 1 then
  require('rust-tools').setup({
    server = { capabilities = capabilities_with_snippets },
    tools = {
      inlay_hints = {
        auto = false,
      },
    },
  })
end

nvim_lsp.sumneko_lua.setup({
  capabilities = capabilities_with_snippets,
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
})

nvim_lsp.tailwindcss.setup({ capabilities = capabilities_with_color })

nvim_lsp.volar.setup({
  capabilities = capabilities_with_snippets,
  init_options = {
    typescript = {
      serverPath = '/usr/lib/node_modules/typescript/lib/tsserverlibrary.js',
    },
  },
})
