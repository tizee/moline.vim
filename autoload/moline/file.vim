scriptencoding utf-8

function! s:is_term()
  return &buftype == 'terminal'
endfunction

function! moline#file#update_style_to_mode_state(edit_mode,comp_name) abort
  let state = get(a:edit_mode,'state','active')
  " udpate highlight when changed
  execute('hi! link Moline_'.a:comp_name.'_active Moline_'.a:comp_name.'_'.state)
endfunction

function! s:get_mode()
  return get(g:moline_buffer_modes,mode(),{})
endfunction

function! moline#file#mode() abort
  let edit_mode = s:get_mode()
  call moline#file#update_style_to_mode_state(edit_mode,'mode')
  return get(l:edit_mode,'txt', '?')
endfunction

" should not use this
" since vim redraws statusline calls frequently
let s:filesize_kb=1024
let s:filesize_mb=1024*1024
let s:filesize_gb=1024*1024*1024
function! moline#file#filesize() abort
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
      \  'help' : '󰞋 HELP',
      \  'nerdtree': ' MENU',
      \  'startify': ' DASHBOARD',
      \  'qf': '󰏬 QUICKFIX',
      \  'terminal': ' Terminal'
      \}

function! moline#file#is_not_specialfile() abort
  if has_key(s:special_filetype,&filetype) || s:is_term()
    return v:false
  endif
  return v:true
endfunction

" construct info for filetypes that have special meaning
function! moline#file#get_specialfile_info() abort
  let file_type=&ft
  if has_key(s:special_filetype,file_type)
    let icon = s:special_filetype[file_type]
    let file_handler = s:filetype_handler_factory(file_type)
    let other = ''
    if !empty(file_handler)
      let other = call(file_handler,[])
    endif
    return icon . ' ' . other
  elseif s:is_term()
    let icon = s:special_filetype['terminal']
    return icon
  endif
  return expand('%')
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
  let file_type=moline#file#filetype()
  let modified=moline#file#modified()
  let filename=''
  if !empty(modified)
    let filename .=modified.' '
  endif
  " let filename.=winwidth(0)>120?'%10t':expand('%:t')
	" the last 15 characters
  let filename.=expand('%:p')[-15:]
  let filesize=moline#file#filesize()
  if s:need_wordcount()
    let file_type.=' '.moline#file#wordcount()
  endif
  if winwidth(0) > 70
    return filesize.' '.filename.' '.file_type
  endif
  if winwidth(0) > 60
    return '%.15f'.' '.file_type
  endif
  if winwidth(0) > 15
    return '%f'
  endif
  return file_type
endfunction

function! moline#file#modified() abort
  if &modified && &modifiable
    return '󰤌'
  endif
  return &readonly ? '' : '󰆢'
endfunction

function! moline#file#rowcol() abort
  " %3l - line number, 3 dight fixed width
  " c - column number (not visual virtual column), 2 fixed width, left
  " justified
  return winwidth(0)>15?'%L/%-3l:%-2c':'%-3l'
endfunction

function! moline#file#fileedit() abort
  " %3l - line number, 3 dight fixed width
  " c - column number (not visual virtual column), 2 fixed width, left
  " justified
  let hex_code = winwidth(0)>60?' 󰅨 %-5B':''
  let rowcol = moline#file#rowcol()
  let percent = moline#file#filepercent()
  if winwidth(0) > 60
    return percent . ' ' . rowcol . hex_code
  endif
  return rowcol
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
  if winwidth(0) < 60
    return ''
  endif
  let current_line = line(".")
  let total_line = line("$") + 1
  let index = len(s:stack) * 0.01 * current_line * 100 / total_line
  let indicator = s:stack[float2nr(index)]
  return indicator.'%3p%%'
endfunction

function! moline#file#fileformat() abort
  let edit_mode=s:get_mode()
  let file_encoding=&fenc !=# '' ? &fenc : &enc
  let file_format="[".&ff."]"
  if winwidth(0) > 60
    call moline#file#update_style_to_mode_state(edit_mode, 'fileformat')
    return file_encoding.file_format
  endif
  if winwidth(0) > 30
      call moline#file#update_style_to_mode_state(edit_mode, 'fileformat')
      return file_encoding
  endif
  " disable highlight
  execute('hi! link Moline_fileformat_active Moline_fileformat_active')
  return ''
endfunction

function! s:need_wordcount() abort
  return (&filetype == 'markdown' || &filetype == 'txt') && winwidth(0)> 80
endfunction

function! moline#file#wordcount()
  let wc=wordcount()
  return wc.words . ' words'
endfunction

