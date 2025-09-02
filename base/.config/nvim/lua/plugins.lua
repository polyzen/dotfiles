local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

---@module 'lazy'
---@type LazySpec
require('lazy').setup({
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'brenoprata10/nvim-highlight-colors',
      'folke/lazydev.nvim',
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
      },
      completion = {
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if ctx.item.source_name == 'LSP' then
                    local color_item =
                      require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr ~= '' then
                      icon = color_item.abbr
                    end
                  end
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  local highlight = 'BlinkCmpKind' .. ctx.kind
                  if ctx.item.source_name == 'LSP' then
                    local color_item =
                      require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr_hl_group then
                      highlight = color_item.abbr_hl_group
                    end
                  end
                  return highlight
                end,
              },
            },
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      fuzzy = { implementation = 'lua' },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
      signature = { enabled = true },
    },
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<space>f',
        function()
          require('conform').format({ async = true })
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        css = { 'prettier' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        json = { 'prettier' },
        lua = { 'stylua' },
        markdown = { 'mdformat' },
        svelte = { 'prettier' },
        typescript = { 'prettier' },
        vue = { 'prettier' },
        yaml = { 'prettier' },
        ['_'] = { 'trim_whitespace', lsp_format = 'last' },
      },
    },
  },
  { 'romainl/vim-cool', event = 'VeryLazy' },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      enhanced_diff_hl = true,
    },
  },
  {
    'junegunn/vim-easy-align',
    keys = {
      {
        'ga',
        '<Plug>(EasyAlign)',
        mode = { 'n', 'x' },
        desc = 'Start interactive EasyAlign',
      },
    },
  },
  { 'Konfekt/FastFold', event = 'VeryLazy' },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('gruvbox')
    end,
  },
  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'virtual',
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
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      sections = {
        lualine_c = { 'filename', "vim.fn['zoom#statusline']()" },
      },
      extensions = {
        'fugitive',
        'lazy',
        'man',
        'neo-tree',
        'quickfix',
        'trouble',
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    events = { 'VeryLazy' },
    opts = {
      lua = { 'selene' },
      markdown = { 'markdownlint-cli2' },
      rst = { 'rstcheck' },
      vim = { 'vint' },
    },
    config = function(_, opts)
      local lint = require('lint')
      lint.linters_by_ft = opts

      vim.api.nvim_create_augroup('nvim_lint', {})
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        group = 'nvim_lint',
        callback = function()
          lint.try_lint()
        end,
      })

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        group = 'nvim_lint',
        pattern = { '*.yaml', '*.yml' },
        callback = function()
          if not vim.uv.fs_stat('node_modules/.bin') then
            lint.try_lint('yamllint')
          end
        end,
      })
    end,
  },
  { 'vimpostor/vim-lumen', lazy = false, priority = 1001 },
  {
    'andymass/vim-matchup',
    init = function()
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_surround_enabled = true
    end,
  },
  {
    'wfxr/minimap.vim',
    event = 'VeryLazy',
    cond = function()
      if vim.fn.executable('code-minimap') == 1 then
        return true
      else
        return false
      end
    end,
  },
  { 'karb94/neoscroll.nvim', event = 'VeryLazy', opts = {} },
  { 'blueyed/vim-qf_resize', event = 'VeryLazy' },
  { 'itchyny/vim-qfedit', event = 'VeryLazy' },
  { 'winston0410/range-highlight.nvim', event = 'CmdlineEnter', opts = {} },
  { 'tversteeg/registers.nvim', event = 'VeryLazy', opts = {} },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  {
    'kaplanz/retrail.nvim',
    opts = {
      trim = { auto = false },
    },
  },
  { 'tpope/vim-rsi', event = 'VeryLazy' },
  { 'matthew-brett/vim-rst-sections', ft = 'rst' },
  {
    'stsewd/sphinx.nvim',
    ft = 'rst',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
  { 'AndrewRadev/splitjoin.vim', event = 'VeryLazy' },
  { 'lambdalisue/suda.vim', event = 'VeryLazy' },
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    opts = {},
  },
  {
    'dhruvasagar/vim-table-mode',
    ft = { 'markdown', 'rst' },
    init = function()
      vim.g.table_mode_syntax = false
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

      local open_with_trouble = require('trouble.sources.telescope').open
      require('telescope').setup({
        defaults = {
          mappings = {
            i = { ['<c-t>'] = open_with_trouble },
            n = { ['<c-t>'] = open_with_trouble },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })
      require('telescope').load_extension('ui-select')
    end,
  },
  { 'markonm/traces.vim', event = 'VeryLazy' },
  { 'andymass/vim-tradewinds', event = 'VeryLazy' },
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = 'andymass/vim-matchup',
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
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
    opts = {},
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'VeryLazy',
    opts = {
      enable_autocmd = false,
    },
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function()
      vim.schedule(function()
        local get_option = vim.filetype.get_option
        vim.filetype.get_option = function(filetype, option)
          return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring()
            or get_option(filetype, option)
        end
      end)
    end,
  },
  { 'folke/twilight.nvim', cmd = 'Twilight', opts = {} },
  { 'tpope/vim-unimpaired', event = 'VeryLazy' },
  { 'folke/which-key.nvim', event = 'VeryLazy' },
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    dependencies = 'folke/twilight.nvim',
    opts = {},
  },
  {
    'dhruvasagar/vim-zoom',
    init = function()
      vim.g['zoom#statustext'] = '🔍 '
    end,
  },

  -- Git
  'hotwatermorning/auto-git-diff',
  'rhysd/committia.vim',
  { 'tpope/vim-fugitive', event = 'VeryLazy' },
  { 'shumphrey/fugitive-gitlab.vim', event = 'VeryLazy' },
  { 'tpope/vim-rhubarb', event = 'VeryLazy' },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
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
  {
    'neovim/nvim-lspconfig',
    dependencies = 'saghen/blink.cmp',
    config = function()
      require('lsp')
    end,
  },
  { 'j-hui/fidget.nvim', opts = {} },
  {
    'kosayoda/nvim-lightbulb',
    event = 'VeryLazy',
    opts = {
      autocmd = { enabled = true },
    },
  },

  -- Language server helpers
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
  },
  {
    'folke/lazydev.nvim',
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
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    cond = function()
      if vim.fn.executable('vscode-json-languageserver') == 1 or vim.fn.executable('yaml-language-server') == 1 then
        return true
      else
        return false
      end
    end,
  },
})
