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
  use({
    'karb94/neoscroll.nvim',
    config = "require('neoscroll').setup()",
  })
  use('ojroques/vim-oscyank')
  use('blueyed/vim-qf_resize')
  use('itchyny/vim-qfedit')
  use({
    'unblevable/quick-scope',
    config = 'vim.g.qs_enable = 0',
  })
  use('AndrewRadev/quickpeek.vim')
  use({
    'winston0410/range-highlight.nvim',
    requires = 'winston0410/cmd-parser.nvim',
    config = "require('range-highlight').setup()",
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
        { 'hrsh7th/cmp-nvim-lsp', branch = 'main' },
        'hrsh7th/cmp-path',
      },
      config = function()
        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
        end

        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = {
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
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
        config = function()
          require('gitsigns').setup({
            on_attach = function(bufnr)
              local function map(mode, lhs, rhs, opts)
                opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
                vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
              end

              -- Navigation
              map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
              map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

              -- Actions
              map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
              map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
              map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
              map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
              map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
              map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
              map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
              map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
              map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
              map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
              map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
              map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
              map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

              -- Text object
              map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
              map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
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
      config = "require('fidget').setup()",
    },
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
    'ray-x/lsp_signature.nvim',
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
