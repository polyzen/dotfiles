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
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
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
    {
      'hrsh7th/nvim-compe',
      config = function()
        require('compe').setup({
          enabled = true,
          source = {
            path = true,
            buffer = true,
            tags = true,
            nvim_lsp = true,
            vsnip = true,
          },
        })
        vim.cmd([[
          inoremap <silent><expr> <C-Space> compe#complete()
          inoremap <silent><expr> <CR>      compe#confirm('<CR>')
          inoremap <silent><expr> <C-e>     compe#close('<C-e>')
          inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
          inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
        ]])
        vim.opt.completeopt = 'menuone,noselect'
      end,
    },
    'rafamadriz/friendly-snippets',
    {
      'hrsh7th/vim-vsnip',
      config = function()
        vim.cmd([[
          imap <expr> <C-j>   vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-j>'
          smap <expr> <C-j>   vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-j>'
          imap <expr> <C-l>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
          smap <expr> <C-l>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
          imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
          smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
          imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
          smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
        ]])
      end,
    },
    'hrsh7th/vim-vsnip-integ',
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
    {
      'liuchengxu/vista.vim',
      config = "vim.g.vista_default_executive = 'nvim_lsp'",
    },
  })
  if vim.fn.executable('ccls') == 1 then
    use({ 'm-pilia/vim-ccls', 'jackguo380/vim-lsp-cxx-highlight' })
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
      requires = { 'nvim-lua/plenary.nvim' },
    })
  end
  require('lsp')
end)
