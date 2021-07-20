function! moline#highlight#init(colorscheme) abort
  let func= 'moline#colorscheme#'.a:colorscheme.'#init'
  return call(func,[])
endfunction

" build highlight group
function! moline#highlight#group(group_name,state,kvs) abort
  let group = printf('Moline_%s_%s',a:group_name,a:state)
  echom 'group:' . group
  for [key,value] in items(a:kvs)
    let group .=' '
    let group .= key.'='.value
  endfor
  execute('highlight ' . group)
  " execute('autocmd VimEnter,ColorScheme * hi ' . group)
endfunction
