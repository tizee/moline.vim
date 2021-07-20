scriptencoding utf-8
if exists('loaded_moline_vim') || &cp || v:version < 700
  finish
endif
let g:loaded_moline_vim = 1

let s:save_cpo=&cpo
set cpo&vim

let g:moline_buffer_modes = {
      \ 'n' :  {
        \  'txt': 'N',
        \  'state': 'normal',
        \  },
        \ 'i' : {
        \  'txt': 'I',
        \  'state': 'insert',
        \  },
        \ 'R' : {
        \  'txt': 'R',
        \  'state': 'insert',
        \  },
        \ 'v' : {
        \  'txt': 'V',
        \  'state': 'visual',
        \  },
        \ 'V' : {
        \  'txt': 'VL',
        \  'state': 'visual',
        \  },
        \ "\<C-v>": {
        \  'txt': 'VB',
        \  'state': 'visual',
        \  },
        \ 'c' : {
        \  'txt': 'C',
        \  'state': 'command',
        \  },
        \ 's' : {
        \  'txt': 'S',
        \  'state': 'select',
        \  },
        \ 'S' : {
        \  'txt': 'SL',
        \  'state': 'select',
        \  },
        \ "\<C-s>": {
        \  'txt': 'SB',
        \  'state': 'select',
        \  },
        \ 't': {
        \  'txt': 'T',
        \  'state': 'terminal',
        \  },
        \ '?': {
        \  'txt': '??',
        \  'state': 'inactive',
        \  },
\}

augroup moline
  autocmd!
  " basic
  autocmd FileType,BufWinEnter,BufEnter,WinEnter,VimResized,TermOpen,FileChangedShellPost * call moline#update(0)
  autocmd WinLeave,BufWinLeave * call moline#update(1)
  " coc
  " autocmd User CocStatusChange,CocGitStatusChange,ClapOnExit,GitGutter,Signify call moline#update(0)
  " autocmd User CocDiagnosticChange call moline#update(0)
augroup END "moline

let &cpo = s:save_cpo
unlet s:save_cpo
