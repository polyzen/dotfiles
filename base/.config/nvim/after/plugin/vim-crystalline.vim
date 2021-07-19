function! MyGitStatusline() abort
  if &modifiable && !empty(get(b:, 'git_dir', ''))
    let l:out = ''
    let l:out .= get(b:,'gitsigns_status','') . ' '
    let l:branch = get(b:,'gitsigns_head','')
    let l:out .= l:branch !=# '' ? '🌳 ' . l:branch : ''
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
    let l:s .= zoom#statusline() . crystalline#right_sep('', 'Fill')
    if a:width > 80
      let l:s .= MyGitStatusline()
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
