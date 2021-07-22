" {{{ General
let g:tar_cmd = 'bsdtar' " Workaround 'unknown extended header' error
set guifont=Fantasque\ Sans\ Mono\ 12
set guioptions-=e " Use 'a non-GUI tab pages line'
set hidden        " Allow hidden buffers
set history=500
set laststatus=2  " Always show status line
set showtabline=2 " .. and tab pages line
set mouse=a       " Enable mouse (esp. for balloons and scrolling in popups)
set noshowmode    " Do not echo the mode, status line will display it instead
set wildmenu      " Enable command-line completion menu
set wildmode=longest:full,full " .. with incremental completions

" Search
set hlsearch      " Highlight matches
set incsearch     " .. while typing
set ignorecase    " Ignore case
set smartcase     " .. unless 'search pattern contains upper case characters'
set shortmess-=S  " 'Show search count message when searching'

" True colors
set termguicolors

" Two-space indentation
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {}
augroup END
" }}}

" {{{ Plugin management
lua require('plugins')

augroup my_lsp_lightbulb
  autocmd!
  autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
augroup END

"  {{{ Mappings
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
imap <expr> <C-j>   vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" }}}
" }}}

" vim: fdm=marker
