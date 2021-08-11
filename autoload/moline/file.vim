" - I love the song 热爱105°C的你
" - It accompanied me along the way writing this pluign

function! s:is_not_term()
  return mode()!='t'
endfunction

function! moline#file#mode() abort
  let mode = get(g:moline_buffer_modes,mode(),{})
  let state = get(mode,'state','active')
  " udpate highlight when changed
  execute('hi! link Moline_mode_active Moline_mode_'.state)
  return ' ' . get(mode,'txt', '??')
endfunction

let s:filesize_kb=1024
let s:filesize_mb=1024*1024
let s:filesize_gb=1024*1024*1024
function! moline#file#fizesize() abort
  let file=expand('%:p')
  if empty(file)
    return ''
  endif
  let bytes=getfsize(file) " bytes
  if bytes<=0
    return ''
  endif
  if bytes < s:filesize_kb " B
    return bytes . ' B'
  elseif bytes < s:filesize_mb
    return bytes/1024. ' kB'
  elseif bytes < s:filesize_gb
    return bytes/1024/1024 . ' mb'
  else
    return bytes/1024/1024/1024 . ' gb'
  endif
endfunction

function! moline#file#buffernumber() abort
  let buffers = []
  for i in range(1, bufnr('$'))
    if bufexists(i) && buflisted(i)
      call insert(buffers, i)
    endif 
  endfor
  for i in range(0, len(buffers)-1)
    if buffers[i] == bufnr('')
      return i
    endif
  endfor
  return -1
endfunction

" speical files {{{
let s:special_filetype= {
      \  'help' : ' HELP',
      \  'nerdtree': ' MENU',
      \  'startify': ' DASHBOARD',
      \  'qf': 'פֿ QUICKFIX',
      \  'terminal': ' Terminal'
      \}

function! moline#file#is_not_specialfile() abort
  if has_key(s:special_filetype,&filetype) && s:is_not_term()
    return 0
  endif
  return 1
endfunction

" construct info for filetypes that have special meaning
function! moline#file#get_specialfile_info() abort
  let ft=&filetype
  if has_key(s:special_filetype,ft)
    let icon = s:special_filetype[ft]
    let file_handler = s:filetype_handler_factory(ft)
    let other = ''
    if !empty(file_handler)
      let other = call(file_handler,[])
    endif 
    return icon . ' ' . other
  elseif mode() == 't'
    let icon = s:special_filetype['terminal']
    return icon
  endif
  return ''
endfunction

let s:special_filetyle_handler={
      \ 'qf': 'moline#file#handle_quickfix_ft',
      \ 'help': 'moline#file#handle_help_ft',
      \}

" Goodbye if-else
function! s:filetype_handler_factory(ft)
  if has_key(s:special_filetyle_handler,a:ft)
    return s:special_filetyle_handler[a:ft]
  endif 
  return ''
endfunction

" handlers {{{
function! moline#file#handle_help_ft()
  " total lines = total quickfix items
  return expand('%:t')
endfunction

function! moline#file#handle_quickfix_ft()
  " total lines = total quickfix items
  return 'Total: %L'
endfunction
" }}}
" }}}

function! moline#file#filename() abort
  let ft=moline#file#filetype()
  let ro = moline#file#readonly()
  let modified=moline#file#modified()
  let filename=winwidth(0)>80?moline#file#fizesize():''
  if !empty(modified)
    let filename .=' ' . modified .' '
  endif
  let filename.=winwidth(0)>120?'%-10t':expand('%:t')
  if moline#file#can_show_wordcount()
    let ft .= ' ' . moline#file#wordcount()
  endif
  if !empty(ro)
    let ft .= ' ' . ro
  endif
  return winwidth(0)>50? (filename . ' ' . ft ): filename 
endfunction

function! moline#file#modified() abort
  if &modified && &modifiable 
    return ''
  endif
  return ''
endfunction

function! moline#file#line() abort
  " %3l - line number, 3 dight fixed width
  " c - column number (not visual virtual column), 2 fixed width, left
  " justified
  return winwidth(0)>100?'  %-3l  %-2c ':''
endfunction

function! moline#file#char() abort
  " %3l - line number, 3 dight fixed width
  " c - column number (not visual virtual column), 2 fixed width, left
  " justified
  return winwidth(0)>100?' '.'%-4B':''
endfunction

function! moline#file#filetype() abort
  let icon = WebDevIconsGetFileTypeSymbol()
  return strlen(&filetype) ? icon : 'no ft'
endfunction

function! moline#file#readonly() abort
  " nerd font
  return &readonly ? '' : ''
endfunction

" let s:pie=['○', '◔', '◑', '◕', '●']
let s:stack= [' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']
function! moline#file#filepercent() abort
  let current_line = line(".")
  let total_line = line("$") + 1
  let index = len(s:stack) * 0.01 * current_line * 100 / total_line
  let indicator = s:stack[float2nr(index)]
  return indicator . ' %-2p%%'
endfunction

function! moline#file#fileformat() abort
  return &ff
endfunction

function! moline#file#fileencoding() abort
  return winwidth(0) > 50 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! moline#file#can_show_wordcount() abort
  return (&filetype == 'markdown' || &filetype == 'txt') && winwidth(0)>=120
endfunction

function! moline#file#wordcount()
  let wc=wordcount()
  return wc.words . ' words'
endfunction

" TODO tabs
function! moline#file#tabname()
endfunction

function! moline#file#tabnumber()
endfunction

