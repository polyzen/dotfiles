set guifont=Fantasque\ Sans\ Mono\ 12
set guioptions-=e " Use 'a non-GUI tab pages line'
set hidden        " Allow hidden buffers
set history=500
set laststatus=2  " Always show status line
set showtabline=2 " .. and tab pages line
set mouse=a       " Enable mouse (esp. for balloons and scrolling in popups)
set noshowmode    " Do not echo the mode, status line will display it instead
set termguicolors " True colors
set wildmenu      " Enable command-line completion menu
set wildmode=longest:full,full " .. with incremental completions

" Search
set hlsearch      " Highlight matches
set incsearch     " .. while typing
set ignorecase    " Ignore case
set smartcase     " .. unless 'search pattern contains upper case characters'
set shortmess-=S  " 'Show search count message when searching'

" Two-space indentation
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {}
augroup END

lua require('plugins')
