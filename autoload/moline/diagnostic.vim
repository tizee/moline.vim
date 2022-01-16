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

" get current services
function! s:get_coc_running_services() abort
  if exists("*CocAction") && !get(g:, 'coc_service_initialized', 0)
    return []
  endif
  let service_list = CocAction("services")
  return copy(filter(service_list, {idx, val -> match(get(val,'state','init'),'running')>=0 }))
endfunction

function! moline#diagnostic#coc_lsp() abort
  let srv_list = s:get_coc_running_services()
  let srv_names=[]
  if len(srv_list) > 0
    " only show the running lsp
    for srv in srv_list
      let srv_names = add(srv_names,get(srv,'id',''))
    endfor
    return ' LSP: ' . join(srv_names," ")
  endif
  return 'No Active LSP'
endfunction
