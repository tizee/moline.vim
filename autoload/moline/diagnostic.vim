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

" get current running services
function! s:get_coc_running_services() abort
  if &ft == '' | return "" | endif
  if exists("*CocAction") && !get(g:, 'coc_service_initialized', 0)
    return ""
  endif
  if win_gettype() == ''
    if &buftype ==# 'terminal' || &buftype ==# 'nofile'
          \ || &buftype ==# 'nofile'
          \ || &buftype ==# 'quickfix'
          \ || &buftype ==# 'prompt'
          \ || &buftype ==# 'acwrite'
          \ || &buftype ==# 'help'
      return ""
    endif
  endif
  return get(g:,"coc_running_services","")
endfunction

function! moline#diagnostic#coc_lsp() abort
  let running_services = s:get_coc_running_services()
  let lsp_str='No Active LSP'
  if len(running_services) > 0
    let lsp_str=running_services
    return ' LSP:'.' '.lsp_str
  endif
  return ""
endfunction
