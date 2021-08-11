function! moline#diagnostic#coc_error() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  let num = get(info,'error',0)
  if num > 0
    return ' ' .  num
  endif 
  return ''
endfunction

function! moline#diagnostic#coc_warn() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  let num = get(info,'error',0)
  if num > 0
    return ' ' . num
  endif 
  return ''
endfunction

function! moline#diagnostic#coc_status() abort
  return get(g:, 'coc_status', '')
endfunction
