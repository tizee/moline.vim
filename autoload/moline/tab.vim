scriptencoding utf-8

" TODO tabs
" return current focuesd buffer's filename and its symbol
function! moline#tab#tabname()
  let file_type=moline#file#filetype()
  let modified=moline#file#modified()
endfunction

" return number of windows in current tab
function! moline#tab#tabnumber()

endfunction
