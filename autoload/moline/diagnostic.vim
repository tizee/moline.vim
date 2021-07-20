function! moline#diagnostic#coc_error() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  return ' ' .  get(info,'error',0)
endfunction

function! moline#diagnostic#coc_warn() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  return ' ' . get(info, 'warning', 0)
endfunction

function! moline#diagnostic#coc_status() abort
  return get(g:, 'coc_status', '')
endfunction
