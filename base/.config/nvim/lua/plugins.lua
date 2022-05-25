local use = require('packer').use

return require('packer').startup(function()
  use('wbthomason/packer.nvim')
  use('ntpeters/vim-better-whitespace')
  use('moll/vim-bbye')
  use({
    'jose-elias-alvarez/buftabline.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('buftabline').setup({
        tab_format = ' #{n}: #{b}#{f} #{i} ',
        buffer_id_index = true,
      })
    end,
  })
  use({
    'norcalli/nvim-colorizer.lua',
    config = require('colorizer').setup(),
  })
  use('romainl/vim-cool')
  use({
    'rbong/vim-crystalline',
    config = function()
      vim.g.crystalline_statusline_fn = 'StatusLine'
      vim.g.crystalline_theme = 'gruvbox'
    end,
  })
  use({
    'sindrets/diffview.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'kyazdani42/nvim-web-devicons', opt = true },
    },
  })
  use('tpope/vim-dispatch')
  use({
    'junegunn/vim-easy-align',
    config = vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)'),
  })
  use('editorconfig/editorconfig-vim')
  use('Konfekt/FastFold')
  use('antoinemadec/FixCursorHold.nvim')
  use({
    'npxbr/gruvbox.nvim',
    config = function()
      vim.g.gruvbox_italic = 1
      local h = tonumber(os.date('%H'))
      if 6 <= h and h < 20 then
        vim.opt.background = 'light'
      end
      vim.cmd('colorscheme gruvbox')
    end,
  })
  use('lewis6991/impatient.nvim')
  use({
    'lukas-reineke/indent-blankline.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('indent_blankline').setup({
        char_list = { '|', '¦', '┆', '┊' },
        filetype_exclude = { 'help' },
        buftype_exclude = { 'terminal' },
        show_current_context = true,
        use_treesitter = true,
      })
    end,
  })
  use({
    'andymass/vim-matchup',
    config = 'vim.g.matchup_matchparen_offscreen = {}',
  })
  if vim.fn.executable('code-minimap') == 1 then
    use('wfxr/minimap.vim')
  end
  use('markwu/vim-mrufiles')
  use({
    'karb94/neoscroll.nvim',
    config = require('neoscroll').setup(),
  })
  use('ojroques/vim-oscyank')
  use('blueyed/vim-qf_resize')
  use('itchyny/vim-qfedit')
  use({
    'unblevable/quick-scope',
    config = 'vim.g.qs_enable = 0',
  })
  use({
    'winston0410/range-highlight.nvim',
    requires = 'winston0410/cmd-parser.nvim',
    config = require('range-highlight').setup(),
  })
  use('tversteeg/registers.nvim')
  use('tpope/vim-repeat')
  use('rhysd/reply.vim')
  use('tpope/vim-rsi')
  use('matthew-brett/vim-rst-sections')
  use({
    'mhinz/vim-signify',
    config = function()
      vim.g.signify_disable_by_default = 1
      vim.g.signify_skip = { vcs = { deny = { 'git' } } }
    end,
  })
  use('stsewd/sphinx.nvim')
  use('AndrewRadev/splitjoin.vim')
  use('lambdalisue/suda.vim')
  use('tpope/vim-surround')
  use('dhruvasagar/vim-table-mode')
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-treesitter/nvim-treesitter', opt = true },
      { 'kyazdani42/nvim-web-devicons', opt = true },
    },
    config = function()
      require('telescope').setup({
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })
      require('telescope').load_extension('ui-select')
    end,
  })
  use('markonm/traces.vim')
  use('andymass/vim-tradewinds')
  use({
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  })
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          disable = { 'c', 'cpp' },
        },
        incremental_selection = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        matchup = {
          enable = true,
        },
      })
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  })
  use({
    'nvim-treesitter/nvim-treesitter-context',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  })
  use({
    'folke/twilight.nvim',
    config = require('twilight').setup(),
  })
  use('tpope/vim-unimpaired')
  use({
    'folke/zen-mode.nvim',
    requires = { 'folke/twilight.nvim', opt = true },
    config = require('zen-mode').setup(),
  })
  use({
    'dhruvasagar/vim-zoom',
    config = "vim.g['zoom#statustext'] = '🔍 '",
  })

  -- Completions
  use({
    'rafamadriz/friendly-snippets',
    {
      'L3MON4D3/LuaSnip',
      config = function()
        require('luasnip/loaders/from_vscode').lazy_load()
      end,
    },
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-buffer',
        'saadparwaiz1/cmp_luasnip',
        { 'hrsh7th/cmp-nvim-lsp', branch = 'main' },
        { 'hrsh7th/cmp-nvim-lsp-signature-help', branch = 'main' },
        'hrsh7th/cmp-path',
      },
      config = function()
        local cmp = require('cmp')

        cmp.setup({
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'buffer' },
          },
        })
      end,
    },
  })

  -- Git
  if vim.fn.executable('git') == 1 then
    use({
      'hotwatermorning/auto-git-diff',
      'rhysd/committia.vim',
      'tpope/vim-fugitive',
      'junegunn/gv.vim',
      'shumphrey/fugitive-gitlab.vim',
      'tpope/vim-rhubarb',
      'rhysd/git-messenger.vim',
      {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
          require('gitsigns').setup({
            on_attach = function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- Navigation
              map('n', ']c', function()
                -- stylua: ignore start
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                -- stylua: ignore end
                return '<Ignore>'
              end, { expr = true })

              map('n', '[c', function()
                -- stylua: ignore start
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                -- stylua: ignore end
                return '<Ignore>'
              end, { expr = true })

              -- Actions
              map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
              map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
              map('n', '<leader>hS', gs.stage_buffer)
              map('n', '<leader>hu', gs.undo_stage_hunk)
              map('n', '<leader>hR', gs.reset_buffer)
              map('n', '<leader>hp', gs.preview_hunk)
              -- stylua: ignore
              map('n', '<leader>hb', function() gs.blame_line({ full = true }) end)
              map('n', '<leader>tb', gs.toggle_current_line_blame)
              map('n', '<leader>hd', gs.diffthis)
              -- stylua: ignore
              map('n', '<leader>hD', function() gs.diffthis('~') end)
              map('n', '<leader>td', gs.toggle_deleted)

              -- Text object
              map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end,
          })
        end,
      },
    })
  end

  -- LSP
  use({
    'neovim/nvim-lspconfig',
    {
      'j-hui/fidget.nvim',
      config = require('fidget').setup(),
    },
    {
      'kosayoda/nvim-lightbulb',
      config = require('nvim-lightbulb').setup({ autocmd = { enabled = true } }),
    },
    {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim' },
    },
    'simrat39/symbols-outline.nvim',
    {
      'liuchengxu/vista.vim',
      config = "vim.g.vista_default_executive = 'nvim_lsp'",
    },
  })
  if vim.fn.executable('ccls') == 1 then
    use({
      {
        'm-pilia/vim-ccls',
        requires = { 'neovim/nvim-lspconfig' },
      },
      'jackguo380/vim-lsp-cxx-highlight',
    })
  end
  if vim.fn.executable('rust-analyzer') == 1 then
    use({
      'simrat39/rust-tools.nvim',
      requires = {
        'neovim/nvim-lspconfig',
        { 'nvim-lua/plenary.nvim', opt = true },
      },
    })
  end
  if vim.fn.executable('typescript-language-server') == 1 then
    use({
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      requires = {
        'neovim/nvim-lspconfig',
        { 'jose-elias-alvarez/null-ls.nvim', opt = true },
        'nvim-lua/plenary.nvim',
      },
    })
  end
end)
