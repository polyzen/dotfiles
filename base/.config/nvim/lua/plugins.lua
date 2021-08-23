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
    config = "require('colorizer').setup()",
  })
  use('romainl/vim-cool')
  use({
    'rbong/vim-crystalline',
    config = function()
      vim.g.crystalline_statusline_fn = 'StatusLine'
      vim.g.crystalline_theme = 'gruvbox'
    end,
  })
  use('tpope/vim-dispatch')
  use({
    'junegunn/vim-easy-align',
    config = function()
      vim.cmd([[
        nmap ga <Plug>(EasyAlign)
        xmap ga <Plug>(EasyAlign)
      ]])
    end,
  })
  use('editorconfig/editorconfig-vim')
  use('Konfekt/FastFold')
  use({
    'npxbr/gruvbox.nvim',
    requires = { 'rktjmp/lush.nvim' },
    config = function()
      vim.g.gruvbox_italic = 1
      local h = tonumber(os.date('%H'))
      if 6 <= h and h < 20 then
        vim.opt.background = 'light'
      end
      vim.cmd('colorscheme gruvbox')
    end,
  })
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
  use('ojroques/vim-oscyank')
  use('blueyed/vim-qf_resize')
  use('itchyny/vim-qfedit')
  use({
    'unblevable/quick-scope',
    config = 'vim.g.qs_enable = 0',
  })
  use('AndrewRadev/quickpeek.vim')
  use('tversteeg/registers.nvim')
  use('tpope/vim-repeat')
  use('rhysd/reply.vim')
  use('tpope/vim-rsi')
  use('matthew-brett/vim-rst-sections')
  use({
    'mhinz/vim-signify',
    config = "vim.g.signify_skip = { vcs = { deny = { 'git' } } }",
  })
  use('AndrewRadev/splitjoin.vim')
  use('lambdalisue/suda.vim')
  use('dhruvasagar/vim-table-mode')
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      { 'nvim-treesitter/nvim-treesitter', opt = true },
      { 'kyazdani42/nvim-web-devicons', opt = true },
    },
  })
  use('cespare/vim-toml')
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
    'romgrk/nvim-treesitter-context',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  })
  use({
    'folke/twilight.nvim',
    config = "require('twilight').setup()",
  })
  use('tpope/vim-unimpaired')
  use({
    'folke/zen-mode.nvim',
    requires = { 'folke/twilight.nvim', opt = true },
    config = "require('zen-mode').setup()",
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
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
      },
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        cmp.setup({
          mapping = {
            ['<C-p>'] = cmp.mapping.prev_item(),
            ['<C-n>'] = cmp.mapping.next_item(),
            ['<C-d>'] = cmp.mapping.scroll(-4),
            ['<C-f>'] = cmp.mapping.scroll(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }),
            ['<Tab>'] = cmp.mapping.mode({ 'i', 's' }, function(_, fallback)
              if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
              elseif luasnip.expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
              else
                fallback()
              end
            end),
            ['<S-Tab>'] = cmp.mapping.mode({ 'i', 's' }, function(_, fallback)
              if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
              elseif luasnip.jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
              else
                fallback()
              end
            end),
          },
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          sources = {
            { name = 'nvim_lsp' },
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
        config = "require('gitsigns').setup()",
      },
    })
  end

  -- LSP
  use({
    'neovim/nvim-lspconfig',
    {
      'kosayoda/nvim-lightbulb',
      config = function()
        vim.cmd([[
          augroup my_lsp_lightbulb
            autocmd!
            autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
          augroup END
        ]])
      end,
    },
    'nvim-lua/lsp-status.nvim',
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
      requires = { 'nvim-lua/plenary.nvim', opt = true },
      config = "require('rust-tools').setup()",
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
