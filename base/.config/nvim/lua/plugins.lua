local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'moll/vim-bbye',
  {
    'jose-elias-alvarez/buftabline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      tab_format = ' #{n}: #{b}#{f} #{i} ',
      buffer_id_index = true,
    },
  },
  {
    'NvChad/nvim-colorizer.lua',
    opts = {
      filetypes = {
        '*',
        '!css',
        '!html',
      },
    },
  },
  {
    'terrortylor/nvim-comment',
    opts = {
      hook = function()
        require('ts_context_commentstring.internal').update_commentstring()
      end,
    },
    main = 'nvim_comment',
  },
  'romainl/vim-cool',
  {
    'rbong/vim-crystalline',
    init = function()
      vim.g.crystalline_separators = {
        { ch = '', alt_ch = '|', dir = '>' },
        { ch = '', alt_ch = '|', dir = '<' },
      }
      vim.g.crystalline_theme = 'gruvbox'

      local function MyGitStatusline()
        if vim.bo.modifiable and vim.fn.FugitiveGitDir() ~= '' then
          local bufnr = vim.fn.bufnr()
          local head = vim.fn.getbufvar(bufnr, 'gitsigns_head')
          local out = ''
          local status = vim.fn.getbufvar(bufnr, 'gitsigns_status')

          out = status ~= '' and out .. status .. ' ' or out
          out = out .. '🌳'
          out = head ~= '' and out .. ' ' .. head or out

          return ' ' .. out
        else
          return ''
        end
      end

      function vim.g.CrystallineStatuslineFn(winnr)
        local cl = require('crystalline')
        local curr = winnr == vim.fn.winnr()
        local s = ''

        if curr then
          s = s .. cl.ModeSection(0, 'A', 'B')
        else
          s = s .. cl.HiItem('Fill')
        end
        s = s .. ' %t%h%w%m%r '
        if curr then
          s = s .. vim.fn['zoom#statusline']() .. cl.Sep(0, 'B', 'Fill')
          if vim.fn.winwidth(winnr) >= 80 then
            s = s .. MyGitStatusline()
          end
        end

        s = s .. '%='
        if curr then
          s = s .. cl.Sep(1, 'Fill', 'B') .. ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
          s = s .. cl.Sep(1, 'B', 'A')
        end
        if vim.fn.winwidth(winnr) >= 80 then
          s = s .. ' %{strlen(&filetype) ? &filetype : ""}'
          s = s .. '[%{&fenc!=#""?&fenc:&enc}][%{&ff}]'
        end
        s = s .. ' %l/%L %c%V %P '

        return s
      end
    end,
  },
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      enhanced_diff_hl = true,
    },
  },
  'tpope/vim-dispatch',
  {
    'mrshmllow/document-color.nvim',
    opts = {
      mode = 'background',
    },
  },
  {
    'junegunn/vim-easy-align',
    init = function()
      vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)')
    end,
  },
  'Konfekt/FastFold',
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('gruvbox')
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      indent = { char = { '|', '¦', '┆', '┊' } },
    },
    main = 'ibl',
  },
  {
    'vimpostor/vim-lumen',
    priority = 1001,
  },
  {
    'andymass/vim-matchup',
    init = function()
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_surround_enabled = 1
    end,
  },
  {
    'wfxr/minimap.vim',
    cond = function()
      if vim.fn.executable('code-minimap') == 1 then
        return true
      else
        return false
      end
    end,
  },
  'markwu/vim-mrufiles',
  {
    'karb94/neoscroll.nvim',
    config = true,
  },
  'ojroques/vim-oscyank',
  'blueyed/vim-qf_resize',
  'itchyny/vim-qfedit',
  {
    'unblevable/quick-scope',
    init = function()
      vim.g.qs_enable = 0
    end,
  },
  {
    'winston0410/range-highlight.nvim',
    dependencies = 'winston0410/cmd-parser.nvim',
    config = true,
  },
  {
    'tversteeg/registers.nvim',
    config = true,
  },
  'tpope/vim-repeat',
  'rhysd/reply.vim',
  {
    'kaplanz/retrail.nvim',
    opts = {
      trim = { auto = false },
    },
  },
  'tpope/vim-rsi',
  'matthew-brett/vim-rst-sections',
  'stsewd/sphinx.nvim',
  'AndrewRadev/splitjoin.vim',
  'lambdalisue/suda.vim',
  'tpope/vim-surround',
  'dhruvasagar/vim-table-mode',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-treesitter/nvim-treesitter', lazy = true },
      'nvim-tree/nvim-web-devicons',
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
  },
  'markonm/traces.vim',
  'andymass/vim-tradewinds',
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-tree').setup()
      local function open_nvim_tree(data)
        local directory = vim.fn.isdirectory(data.file) == 1
        if not directory then
          return
        end
        vim.cmd.cd(data.file)
        require('nvim-tree.api').tree.open()
      end

      vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      context_commentstring = {
        enable_autocmd = false,
      },
      matchup = {
        enable = true,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      require('nvim-treesitter.install').prefer_git = true
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
    build = ':TSUpdate',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  'JoosepAlviste/nvim-ts-context-commentstring',
  {
    'folke/twilight.nvim',
    config = true,
  },
  'tpope/vim-unimpaired',
  {
    'folke/zen-mode.nvim',
    dependencies = { 'folke/twilight.nvim', lazy = true },
    config = true,
  },
  {
    'dhruvasagar/vim-zoom',
    init = function()
      vim.g['zoom#statustext'] = '🔍 '
    end,
  },

  -- Completions
  'rafamadriz/friendly-snippets',
  {
    'L3MON4D3/LuaSnip',
    config = function()
      require('luasnip/loaders/from_vscode').lazy_load()
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      { 'hrsh7th/cmp-nvim-lsp', branch = 'main' },
      'hrsh7th/cmp-path',
    },
    opts = function()
      local cmp = require('cmp')

      return {
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
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        },
      }
    end,
  },

  -- Git
  'hotwatermorning/auto-git-diff',
  'rhysd/committia.vim',
  'tpope/vim-fugitive',
  'junegunn/gv.vim',
  'shumphrey/fugitive-gitlab.vim',
  'tpope/vim-rhubarb',
  'rhysd/git-messenger.vim',
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<leader>hr', gs.reset_hunk)
        map('v', '<leader>hs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map('v', '<leader>hr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function()
          gs.blame_line({ full = true })
        end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function()
          gs.diffthis('~')
        end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },

  -- LSP
  'neovim/nvim-lspconfig',
  {
    'j-hui/fidget.nvim',
    config = true,
  },
  {
    'kosayoda/nvim-lightbulb',
    opts = {
      autocmd = { enabled = true },
    },
  },
  {
    'lvimuser/lsp-inlayhints.nvim',
    config = true,
  },
  {
    'ray-x/lsp_signature.nvim',
    config = true,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim' },
  },
  'b0o/SchemaStore.nvim',
  {
    'simrat39/symbols-outline.nvim',
    config = true,
  },
  {
    'liuchengxu/vista.vim',
    init = function()
      vim.g.vista_default_executive = 'nvim_lsp'
    end,
  },
  {
    'p00f/clangd_extensions.nvim',
    cond = function()
      if vim.fn.executable('clangd') == 1 then
        return true
      else
        return false
      end
    end,
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  {
    'folke/neodev.nvim',
    cond = function()
      if vim.fn.executable('lua-language-server') == 1 then
        return true
      else
        return false
      end
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    cond = function()
      if vim.fn.executable('rust-analyzer') == 1 then
        return true
      else
        return false
      end
    end,
    dependencies = {
      'neovim/nvim-lspconfig',
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
  },
  {
    'jose-elias-alvarez/typescript.nvim',
    cond = function()
      if vim.fn.executable('typescript-language-server') == 1 then
        return true
      else
        return false
      end
    end,
    dependencies = { 'neovim/nvim-lspconfig' },
  },
})
