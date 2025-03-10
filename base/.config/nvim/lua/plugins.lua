local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
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
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'virtual',
      enable_tailwind = true,
    },
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
  {
    'matthew-brett/vim-rst-sections',
    ft = { 'rst' },
  },
  {
    'stsewd/sphinx.nvim',
    ft = { 'rst' },
  },
  'AndrewRadev/splitjoin.vim',
  'lambdalisue/suda.vim',
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = true,
  },
  {
    'dhruvasagar/vim-table-mode',
    ft = { 'markdown', 'rst' },
  },
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
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false,
    },
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
      vim.schedule(function()
        local get_option = vim.filetype.get_option
        vim.filetype.get_option = function(filetype, option)
          return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring()
            or get_option(filetype, option)
        end
      end)
    end,
  },
  {
    'folke/twilight.nvim',
    config = true,
  },
  'tpope/vim-unimpaired',
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
  },
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
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      { 'hrsh7th/cmp-nvim-lsp', branch = 'main' },
      'hrsh7th/cmp-path',
      'garymjr/nvim-snippets',
    },
    opts = function()
      local cmp = require('cmp')

      return {
        formatting = {
          format = require('nvim-highlight-colors').format,
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
          { name = 'snippets' },
          { name = 'path' },
          { name = 'buffer' },
        },
      }
    end,
  },
  {
    'garymjr/nvim-snippets',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'rafamadriz/friendly-snippets',
    },
    opts = {
      friendly_snippets = true,
    },
    keys = {
      {
        '<Tab>',
        function()
          if vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
            return
          end
          return '<Tab>'
        end,
        expr = true,
        silent = true,
        mode = 'i',
      },
      {
        '<Tab>',
        function()
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        end,
        expr = true,
        silent = true,
        mode = 's',
      },
      {
        '<S-Tab>',
        function()
          if vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
            return
          end
          return '<S-Tab>'
        end,
        expr = true,
        silent = true,
        mode = { 'i', 's' },
      },
    },
  },
  'rafamadriz/friendly-snippets',

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
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('v', '<leader>hr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hi', gitsigns.preview_hunk_inline)

        map('n', '<leader>hb', function()
          gitsigns.blame_line({ full = true })
        end)

        map('n', '<leader>hd', gitsigns.diffthis)

        map('n', '<leader>hD', function()
          gitsigns.diffthis('~')
        end)

        map('n', '<leader>hQ', function()
          gitsigns.setqflist('all')
        end)
        map('n', '<leader>hq', gitsigns.setqflist)

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>tw', gitsigns.toggle_word_diff)

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
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
    ft = { 'c', 'cpp' },
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
    'folke/lazydev.nvim',
    ft = { 'lua' },
    cond = function()
      if vim.fn.executable('lua-language-server') == 1 then
        return true
      else
        return false
      end
    end,
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    cond = function()
      if vim.fn.executable('rust-analyzer') == 1 then
        return true
      else
        return false
      end
    end,
  },
})
