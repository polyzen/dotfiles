local use = require('packer').use

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = { "c", "cpp" },
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
      }
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  }
  use 'ntpeters/vim-better-whitespace'
  use 'moll/vim-bbye'
  use {
    'jose-elias-alvarez/buftabline.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('buftabline').setup {
        buffer_id_index = true,
        icons = true,
        icon_colors = true,
      }
    end,
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = [[require('colorizer').setup()]],
  }
  use 'romainl/vim-cool'
  use {
    'rbong/vim-crystalline',
    config = function()
      vim.g.crystalline_statusline_fn = 'StatusLine'
      vim.g.crystalline_theme = 'gruvbox'
    end,
  }
  use 'tpope/vim-dispatch'
  use 'junegunn/vim-easy-align'
  use 'editorconfig/editorconfig-vim'
  use 'Konfekt/FastFold'
  use { 'junegunn/goyo.vim', 'junegunn/limelight.vim' }
  use {
    'npxbr/gruvbox.nvim',
    requires = { 'rktjmp/lush.nvim' },
    config = function()
      vim.g.gruvbox_italic = 1
      local h = tonumber(os.date("%H"))
      if 6 <= h and h < 20 then vim.opt.background = "light" end
      vim.cmd[[colorscheme gruvbox]]
    end,
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      vim.g.indent_blankline_char_list = { '|', '¦', '┆', '┊' }
      vim.g.indent_blankline_filetype_exclude = { 'help' }
      vim.g.indent_blankline_buftype_exclude = { 'terminal' }
      vim.g.indent_blankline_use_treesitter = true
    end,
  }
  use {
    'andymass/vim-matchup',
    config = [[vim.g.matchup_matchparen_offscreen = {}]],
  }
  if vim.fn.executable('code-minimap') == 1 then
    use 'wfxr/minimap.vim'
  end
  use 'markwu/vim-mrufiles'
  use 'ojroques/vim-oscyank'
  use 'junegunn/vim-peekaboo'
  use 'blueyed/vim-qf_resize'
  use 'itchyny/vim-qfedit'
  use {
    'unblevable/quick-scope',
    config = [[vim.g.qs_enable = 0]],
  }
  use 'AndrewRadev/quickpeek.vim'
  use 'tpope/vim-repeat'
  use 'rhysd/reply.vim'
  use 'tpope/vim-rsi'
  use 'matthew-brett/vim-rst-sections'
  use {
    'mhinz/vim-signify',
    config = [[vim.g.signify_skip = { vcs = { deny = { 'git' } } }]],
  }
  use 'AndrewRadev/splitjoin.vim'
  use 'lambdalisue/suda.vim'
  use 'dhruvasagar/vim-table-mode'
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-treesitter/nvim-treesitter', opt = true },
      { 'kyazdani42/nvim-web-devicons', opt = true },
    },
  }
  use 'cespare/vim-toml'
  use 'markonm/traces.vim'
  use 'andymass/vim-tradewinds'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }
  use {
    'romgrk/nvim-treesitter-context',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }
  use 'tpope/vim-unimpaired'
  use {
    'dhruvasagar/vim-zoom',
    config = [[vim.g['zoom#statustext'] = '🔍 ']],
    }

  -- Completions
  use {
    {
      'hrsh7th/nvim-compe',
      config = function()
        require('compe').setup {
          enabled = true,
          source = {
            path = true,
            buffer = true,
            tags = true,
            nvim_lsp = true,
            vsnip = true,
          },
        }
        vim.opt.completeopt = 'menuone,noselect'
      end,
    },
    'rafamadriz/friendly-snippets',
    'hrsh7th/vim-vsnip',
    'hrsh7th/vim-vsnip-integ',
  }

  -- Git
  if vim.fn.executable('git') == 1 then
    use {
      'hotwatermorning/auto-git-diff',
      'rhysd/committia.vim',
      'tpope/vim-fugitive', 'junegunn/gv.vim',
      'shumphrey/fugitive-gitlab.vim', 'tpope/vim-rhubarb',
      'rhysd/git-messenger.vim',
      {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = [[require('gitsigns').setup()]],
      }
    }
  end

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    'kosayoda/nvim-lightbulb',
    {
      'liuchengxu/vista.vim',
      config = [[vim.g.vista_default_executive = 'nvim_lsp']],
    },
  }
  if vim.fn.executable('ccls') == 1 then
    use { 'm-pilia/vim-ccls', 'jackguo380/vim-lsp-cxx-highlight' }
  end
  if vim.fn.executable('rust-analyzer') == 1 then
    use {
      'simrat39/rust-tools.nvim',
      requires = { 'nvim-lua/plenary.nvim', opt = true },
      config = [[require('rust-tools').setup()]],
    }
  end
  if vim.fn.executable('typescript-language-server') == 1 then
    use {
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      requires = { 'nvim-lua/plenary.nvim' },
    }
  end
  require('lsp')
end)
