function! MyVCSStatusline() abort
  if &modifiable
    let l:head = ''
    let l:out = ' '
    let l:status = ''
    let l:vcs = ''
    if !empty(get(b:, 'git_dir', ''))
      let l:status = get(b:,'gitsigns_status','')
      let l:head = get(b:,'gitsigns_head','')
    elseif !empty(get(b:, 'sy')) && !empty(get(b:sy, 'vcs'))
      let l:status = sy#repo#get_stats_decorated()
      let l:vcs = get(b:sy, 'vcs')[0]
    else
      return ''
    endif
    let l:out .= l:status !=# '' ? l:status . ' ' : ''
    let l:out .= '🌳'
    let l:out .= l:head !=# '' ? ' ' . l:head : ''
    let l:out .= l:vcs !=# '' ? ' ' . l:vcs : ''
    return l:out
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
      let l:s .= MyVCSStatusline()
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
