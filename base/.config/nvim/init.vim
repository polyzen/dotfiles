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
set smartcase     " .. unless 'the search pattern contains upper case characters'
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
imap <expr> <C-j>   vsnip#expandable() ? '<  use>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable() ? '<  use>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1) ? '<  use>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1) ? '<  use>(vsnip-expand-or-jump)' : '<C-l>'
imap <expr> <Tab>   vsnip#jumpable(1)  ? '<  use>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<  use>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<  use>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<  use>(vsnip-jump-prev)'      : '<S-Tab>'

nmap ga <  use>(EasyAlign)
xmap ga <  use>(EasyAlign)
" }}}

" {{{ Status line
function! MyGitStatusline() abort
  if &modifiable && !empty(get(b:, 'git_dir', ''))
    let l:out = ''
    if has('nvim')
      let l:out .= get(b:,'gitsigns_status','') . ' '
      let l:branch = get(b:,'gitsigns_head','')
    else
      if g:gitgutter_enabled
        let [l:added, l:modified, l:removed] = GitGutterGetHunkSummary()
        let l:out .= printf('+%d ~%d -%d ', l:added, l:modified, l:removed)
      endif
      let l:branch = FugitiveHead()
    endif
    let l:out .= l:branch !=# '' ? "\ue0a0 " . l:branch : ''
    return !empty(l:out) ? ' ' . l:out : ''
  else
    return ''
  endif
endfunction

function! StatusLine(current, width)
  let l:s = ''

  if a:current
    let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
  else
    let l:s .= '%#CrystallineInactive#'
  endif
  let l:s .= ' %t%h%w%m%r '
  if a:current
    let l:s .= '%{zoom#statusline()}' . crystalline#right_sep('', 'Fill')
    if a:width > 80
      let l:s .= '%{MyGitStatusline()}'
    endif
  endif

  let l:s .= '%='
  if a:current
    let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
    let l:s .= crystalline#left_mode_sep('')
  endif
  if a:width > 80
    let l:s .= ' %{strlen(&filetype) ? &filetype : ""}'
    let l:s .= '[%{&fenc!=#""?&fenc:&enc}][%{&ff}]'
  else
  endif
  let l:s .= ' %l/%L %c%V %P '

  return l:s
endfunction
" }}}
" }}}

" vim: fdm=marker
