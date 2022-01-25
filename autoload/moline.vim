scriptencoding utf-8

" TODO tab
let s:default_moline= {
      \ 'colorscheme': 'dracula',
      \ 'active': { 'left': ['mode','filename','error','warn','status'], 'mid':['lsp'], 'right': ['vcs','line','char','percent','fileencoding','fileformat'], },
      \ 'inactive': { 'left': ['filename','error','warn','status'], 'right': ['fileencoding', 'fileformat'] },
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
  let res = []
  let section = []
  if a:inactive
    let section = copy(get(s:moline.inactive,a:pos,[]))
  else
    let section = copy(get(s:moline.active,a:pos,[]))
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

function! moline#get_comp_state(comp_name,inactive)
  if a:comp_name == 'warn' || a:comp_name == 'error'
    return a:comp_name
  endif
  return a:inactive?'inactive':'active'
endfunction

function! s:get_section_comps(section,pos,inactive)
  let res=''
  for f in a:section
    if has_key(s:moline.comps,f) " has comp func
      let producer=s:moline.comps[f].producer
      let minWidth = get(s:moline.comps[f],'minWidth','')
      if !empty(minWidth)
        let minWidth = '%'. minWidth
      endif 
      let comp_class = get(s:moline.comps[f],'class','default')
      "  acitve or inactive via compStateProducer func
      let comp_state = call(s:moline.compStateProducer,[f,a:inactive])
      let hlGroup = s:build_hlgroup(comp_class,comp_state)
      " buffer dependent
      let comp = hlGroup ."%{%". producer ."()%}"
      let fill_section = '%#Moline_default_active# ' 
      if !a:pos=='left'
        if has_key(s:moline.comps[f],'sep')
          let res.=s:moline.comps[f]['sep']
          let res.="\ "
        endif 
       else
          let res.=fill_section
      endif " right end
      let res.=comp
      if a:pos=='left'
        if has_key(s:moline.comps[f],'sep')
          let res.="\ "
          let res.=s:moline.comps[f]['sep']
        endif 
       else
          let res.=fill_section
      endif  " left end
    endif
  endfor
  return res
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
    return left_section . fill_section . mid_section . fill_section . right_section
  endif
  return left_section .  " %= " . right_section
endfunction

" moline status: 
" 1 - update/build config 
" 2 - render update
" 3 - disable
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
