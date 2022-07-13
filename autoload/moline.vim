scriptencoding utf-8
"""  Configuration options
" 1. colorscheme: colorscheme name requires string
" 
" 2. display sections
" 2.1 current buffer
" active: {
"  left: left section requires array of components
"  mid: middle section requires array of components
"  right: right section requires array of components
" }
" 2.2  inactive buffers
" inactive: {
"  left: left section requires array of components
"  mid: middle section requires array of components
"  right: right section requires array of components
" }
" 2.3 
" compStateProducer
"
"""

let s:default_moline= {
      \ 'colorscheme': 'gruvbox',
      \ 'active': { 'left': ['mode','filename','error','warn'], 'mid':['lsp'], 'right': ['vcs','fileedit','fileformat'], },
      \ 'inactive': { 'left': ['mode','filename','error','warn'],'mid':[], 'right': ['fileedit', 'fileformat'] },
      \ 'compStateProducer': 'moline#get_comp_state',
      \ 'comps': {
          \ 'lsp': {
          \  'producer': 'moline#diagnostic#coc_lsp',
          \  'visible': 'moline#file#is_not_specialfile',
          \ 'class': 'lsp',
          \  },
        \ 'status': {
          \ 'producer': 'moline#diagnostic#coc_status',
          \ 'visible': 'moline#file#is_not_specialfile',
          \  },
          \ 'vcs': {
          \  'producer': 'moline#vcs#git',
          \  'visible': 'moline#file#is_not_specialfile',
          \  },
          \ 'fileedit': {
          \  'producer': 'moline#file#fileedit',
          \  'visible': 'moline#file#is_not_specialfile',
          \  },
          \  'mode': {
          \  'producer': 'moline#file#mode',
          \  'visible': 'moline#file#is_not_specialfile',
          \  'class': 'mode',
          \  'left_sep':'█'
          \  },
          \ 'filename': {
          \  'producer': 'moline#file#filename',
          \  'visible': 'moline#file#is_not_specialfile',
          \  'fallback': 'special_files',
          \  'class': 'filename',
          \  },
          \ 'special_files':{
          \  'producer': 'moline#file#get_specialfile_info',
          \  'class': 'filename',
          \},
          \ 'error': {
          \  'producer': 'moline#diagnostic#coc_error',
          \  'visible': 'moline#file#is_not_specialfile',
          \  'class': 'diagnostic',
          \  },
          \ 'warn': {
          \  'producer': 'moline#diagnostic#coc_warn',
          \  'visible': 'moline#file#is_not_specialfile',
          \  'class': 'diagnostic',
          \  },
          \ 'fileformat': {
          \  'producer': 'moline#file#fileformat',
          \  'class': 'fileformat',
          \  'right_sep':'█'
          \  },
          \},
      \}

function! s:cache_config() abort
  let s:moline = deepcopy(get(g:,'moline', {}))
  " default_moline merge into user defined moline
  for [key,value] in items(s:default_moline)
    if type(value) == 4 " dict
      if !has_key(s:moline,key)
        let s:moline[key]={}
      endif 
      call extend(s:moline[key],value,'keep')
    elseif !has_key(s:moline,key)
      let s:moline[key] = value " use default components if not defined
    endif 
  endfor
endfunction

function! s:remove_invisible_comp(pos,inactive) abort
  let result = []
  let section = []
  if a:inactive
    let section = get(s:moline.inactive,a:pos,[])
  else
    let section = get(s:moline.active,a:pos,[])
  endif 
  " iterate over section by calling component function
  for name in section
    "  call only when there is a implementation
    if has_key(s:moline.comps,name) 
      if has_key(s:moline.comps[name],'visible')
        " whether visible
        let visible=call(s:moline.comps[name]['visible'],[])
        if visible
          call add(result, name)
        elseif has_key(s:moline.comps[name],'fallback')
          call add(result, s:moline.comps[name]['fallback'])
        endif
      else 
        " always visible
        call add(result, name)
      endif
    endif
  endfor
  return result
endfunction

function! s:setup_moline() abort
  let s:option_statusline=&statusline
  call s:cache_config()
  " color scheme init
  call moline#highlight#init(s:moline.colorscheme)
endfunction

function! s:restore_statusline() abort
  for i in range(1, winnr('$'))
    call setwinvar(i, '&statusline', s:option_statusline)
  endfor
endfunction

function! s:is_active()
 let current = get(g:,'statusline_winid',0)
 return current==win_getid()
endfunction

" use to generate name of state for corresponding highlight group
function! moline#get_comp_state(comp_name,inactive)
  if a:comp_name == 'warn' || a:comp_name == 'error'
    return a:comp_name
  endif
  return a:inactive?"inactive":"active"
endfunction

function! s:render_comp(component,name,pos,inactive) abort
    let result=''
    let producer=a:component.producer
    " get class name of highlight group
    let comp_class = get(a:component,'class','default')
    "  acitve or inactive via compStateProducer func
    let comp_state = call(s:moline.compStateProducer,[a:name,a:inactive])
    let comp_hlgroup= s:build_hlgroup(comp_class,comp_state)
    " buffer dependent
    let comp_str= comp_hlgroup ."%{%". producer ."()%}"
    " resultet style

    let fill_section = a:inactive?'%#Moline_default_inactive#':'%#Moline_default_active#'
    let result.=fill_section
    if get(a:component,'left_sep') != ''
        let result.=comp_hlgroup
        let result.=get(a:component,'left_sep','')
    elseif get(a:component,'sep') != ''
        let result.=comp_hlgroup
        let result.=get(a:component,'sep','')
    endif
    let result.=' '.comp_str.' '
    if get(a:component,'right_sep') != ''
        let result.=get(a:component,'right_sep','')
    elseif get(a:component,'sep') != ''
        let result.=get(a:component,'sep','')
    endif
    return result
endfunction

" render component to vim's statusline string
function! s:get_section_comps(section,pos,inactive) abort
  let result=""
  for name in a:section
    if has_key(s:moline.comps,name) " has comp func
      let result.=s:render_comp(s:moline.comps[name],name,a:pos, a:inactive)
    endif
  endfor
  echomsg 
  return result
endfunction

function! s:build_hlgroup(class, state) abort
  return '%#Moline_'.a:class.'_'.a:state.'#'
endfunction

function! s:build_statusline(inactive) abort
  let fill_section = '%#Moline_default_active#%=' 
  let left_section = s:remove_invisible_comp('left',a:inactive)
  let right_section = s:remove_invisible_comp('right',a:inactive)
  let mid_section = s:remove_invisible_comp('mid', a:inactive)
  let left_section = s:get_section_comps(left_section,'left',a:inactive)
  let right_section = s:get_section_comps(right_section,'right',a:inactive)
  if len(mid_section) > 0
    let mid_section = s:get_section_comps(mid_section,'mid',a:inactive)
    return left_section.fill_section.mid_section.fill_section.right_section
  endif
  return left_section." %= ".right_section
endfunction

" moline status: 
" 1 - uninitialized
" 2 - render update
" 3 - disable
let s:moline_state=1

function! s:skip_wintype() abort
  return win_gettype() ==# 'popup' ||win_gettype() ==# 'autocmd'
endfunction

function! moline#update() abort
  if s:skip_wintype()
    return
  endif
  if s:moline_state
    if s:moline_state == 3
      call s:restore_statusline()
      return
    endif
    " copy moline config, init colorscheme
    call s:setup_moline()
  endif
    " set statusline for all windows
    let current_w= winnr()
    let modes= winnr('$') == 1 && current_w > 0? [s:build_statusline(0)]:[s:build_statusline(0),s:build_statusline(1)]
    for i in range(1, winnr('$'))
      call setwinvar(i, '&statusline',modes[i!=current_w])
    endfor
endfunction

function! moline#disable() abort
  let s:moline_state=3
  call setwinvar(0, '&statusline', '')
endfunction

function! moline#toggle() abort
  if get(g:,'loaded_moline_vim',0) == 1
    call moline#update(0)
  else
    setl &statusline=''
  endif
endfunction

" Utilities {{{
function! s:log(msg) abort
  echomsg '[moline]: '.a:msg
endfunction
" }}}
