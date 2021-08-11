scriptencoding utf-8

" TODO tab

let s:default_moline= {
      \ 'colorscheme': 'dracula',
      \ 'active': { 'left': ['mode','filename','error','warn','status'], 'right': ['vcs','line','char','fileencoding','fileformat'], },
      \ 'inactive': { 'left': ['filename','error','warn','status'], 'right': ['fileencoding', 'fileformat'] },
      \ 'compStateProducer': 'moline#get_comp_state',
      \ 'comps': {
        \ 'status': {
          \ 'producer': 'moline#diagnostic#coc_status',
          \ 'visible': 'moline#file#is_not_specialfile'
          \},
          \ 'percent': {
          \  'producer': 'moline#file#filepercent',
          \  'visible': 'moline#file#is_not_specialfile',
          \  },
          \ 'vcs': {
          \  'producer': 'moline#vcs#git',
          \  'visible': 'moline#file#is_not_specialfile',
          \  },
          \ 'char': {
          \  'producer': 'moline#file#char',
          \  'visible': 'moline#file#is_not_specialfile',
          \  },
          \ 'line': {
          \  'producer': 'moline#file#line',
          \  'visible': 'moline#file#is_not_specialfile',
          \  },
          \  'mode': {
          \  'producer': 'moline#file#mode',
          \  'minWidth': '-3',
          \  'visible': 'moline#file#is_not_specialfile',
          \  'class': 'mode',
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
          \ 'fileencoding': {
          \  'producer': 'moline#file#fileencoding',
          \  'visible': 'moline#file#is_not_specialfile',
          \  },
          \ 'fileformat': {
          \  'producer': 'moline#file#fileformat',
          \  'visible': 'moline#file#is_not_specialfile',
          \  },
          \},
      \}

function! s:cache_config()
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

function! s:remove_invisible_comp(left,inactive) abort
  let res = []
  let section = []
  if a:inactive
    let section = copy(s:moline.inactive[a:left?'left':'right'])
  else
    let section = copy(s:moline.active[a:left?'left':'right'])
  endif 
  for f in section
    if has_key(s:moline.comps,f) && has_key(s:moline.comps[f],'visible')
      let visible=call(s:moline.comps[f]['visible'],[])
      if visible
        call add(res, f)
      elseif has_key(s:moline.comps[f],'fallback')
        call add(res, s:moline.comps[f]['fallback'])
      endif
    endif
  endfor
  return res
endfunction

function! s:setup_moline()
  let s:option_statusline=&statusline
  call s:cache_config()
  " color scheme init
  call moline#highlight#init(s:moline.colorscheme)
endfunction

function! s:restore_statusline()
  for i in range(1, winnr('$'))
    call setwinvar(i, '&statusline', s:option_statusline)
  endfor
endfunction

function! s:is_active()
 let current = get(g:,'statusline_winid',0)
 return current==win_getid()
endfunction

" TODO use factory
function! moline#get_comp_state(comp_name,inactive)
  if a:comp_name == 'warn' || a:comp_name == 'error'
    return a:comp_name
  endif
  return a:inactive?'inactive':'active'
endfunction

function! s:get_section_comps(section,left,inactive)
  let res=''
  for f in a:section
    if has_key(s:moline.comps,f) " has comp func
      let producer=s:moline.comps[f].producer
      let minWidth = get(s:moline.comps[f],'minWidth','')
      if !empty(minWidth)
        let minWidth = '%'. minWidth
      endif 
      let comp_class = get(s:moline.comps[f],'class','default')
      let comp_state = call(s:moline.compStateProducer,[f,a:inactive])
      let hlGroup = '%#Moline_'.comp_class.'_'.comp_state.'#'
      " buffer dependent
      let comp = hlGroup ."%{%". producer ."()%}"
      if !a:left
        if has_key(s:moline.comps[f],'sep')
          let res.=s:moline.comps[f]['sep']
          let res.="\ "
        endif 
       else
          let res.="\ "
      endif " right end
      let res.=comp
      if a:left
        if has_key(s:moline.comps[f],'sep')
          let res.="\ "
          let res.=s:moline.comps[f]['sep']
        endif 
       else
          let res.="\ "
      endif  " left end
    endif
  endfor
  return res
endfunction

function! s:join_sections(left,right,inactive)
  let left_res = s:get_section_comps(a:left,1,a:inactive)
  let right_res= s:get_section_comps(a:right,0,a:inactive)
  return left_res. " %= ". right_res
endfunction

function! s:build_statusline(inactive) abort
  let left_section = s:remove_invisible_comp(1,a:inactive)
  let right_section = s:remove_invisible_comp(0,a:inactive)
  let res = s:join_sections(left_section,right_section,a:inactive)
  unlet left_section
  unlet right_section
  return res
endfunction

" moline status: 
" 1 - update/build config 
" 2 - render update
" 3 - disable
" 1 -> 2 
" 2 -> 3
" 3 -> 1
let s:moline_state=1

function! moline#update(inactive) abort
  if get(g:,'loaded_moline_vim',0) != 1
    return
  endif
  if s:moline_state == 1
    call s:setup_moline()
    let s:moline_state = 2
  endif
  if s:moline_state == 2
    let line=s:build_statusline(a:inactive)
    call setwinvar(winnr(), '&statusline',line)
  elseif s:moline_state == 3
    call s:restore_statusline()
  endif 
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
