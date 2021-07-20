scriptencoding utf-8

" [gui, cterm]
let s:palette = {
    \ "color01" : ['#F8F8F2', 253],
    \ "color02" : ['#424450', 238],
    \ "color03" : ['#343746', 237],
    \ "color04" : ['#282A36', 236],
    \ "color05" : ['#21222C', 235],
    \ "color06" : ['#191A21', 234],
    \ "color07" : ['#6272A4',  61],
    \ "color08" : ['#44475A', 239],
    \ "cyan"    : ['#8BE9FD', 117],
    \ "green"   : ['#50FA7B',  84],
    \ "orange"  : ['#FFB86C', 215],
    \ "pink"    : ['#FF79C6', 212],
    \ "purple"  : ['#BD93F9', 141],
    \ "red"     : ['#FF5555', 203],
    \ "yellow"  : ['#F1FA8C', 228],
    \  }

let s:inactive = {
      \ 'gui'   : 'italic',
      \ 'cterm' : 'italic',
      \ 'guifg'   : s:palette.color08[0],
      \ 'guibg'   : s:palette.color01[0],
      \ 'ctermfg' : s:palette.color08[1],
      \ 'ctermbg' : s:palette.color01[1],
      \}

let s:colors = {
      \ 'default': {
        \ 'inactive': s:inactive,
        \ 'active': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg'   : s:palette.color01[0],
              \ 'guibg'   : s:palette.color08[0],
              \ 'ctermfg' : s:palette.color01[1],
              \ 'ctermbg' : s:palette.color08[1],
          \ },
      \},
      \  'mode': {
              \ 'active': s:inactive, 
              \ 'inactive': s:inactive,
              \ 'normal': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.cyan[0],
              \ 'guibg': s:palette.color08[0],
              \ 'ctermfg': s:palette.cyan[1],
              \ 'ctermbg': s:palette.color08[1],
              \ },
              \ 'insert': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.green[0],
              \ 'guibg': s:palette.color08[0],
              \ 'ctermfg': s:palette.green[1],
              \ 'ctermbg': s:palette.color08[1],
              \ },
              \ 'visual': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.orange[0],
              \ 'guibg': s:palette.color08[0],
              \ 'ctermfg': s:palette.orange[1],
              \ 'ctermbg': s:palette.color08[1],
              \ },
              \ 'command': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.pink[0],
              \ 'guibg': s:palette.color08[0],
              \ 'ctermfg': s:palette.pink[1],
              \ 'ctermbg': s:palette.color08[1],
              \ },
              \ 'select': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.yellow[0],
              \ 'guibg': s:palette.color08[0],
              \ 'ctermfg': s:palette.yellow[1],
              \ 'ctermbg': s:palette.color08[1],
              \ },
              \ 'terminal': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.purple[0],
              \ 'guibg': s:palette.color08[0],
              \ 'ctermfg': s:palette.purple[1],
              \ 'ctermbg': s:palette.color08[1],
              \ },
      \},
      \ 'diagnostic': {
        \ 'inactive': s:inactive,
        \ 'error': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.red[0],
              \ 'guibg': s:palette.color08[0],
              \ 'ctermfg': s:palette.red[1],
              \ 'ctermbg': s:palette.color08[1],
        \   },
        \ 'warn': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.orange[0],
              \ 'guibg': s:palette.color08[0],
              \ 'ctermfg': s:palette.orange[1],
              \ 'ctermbg': s:palette.color08[1],
              \ }
      \ },
      \ 'filename': {
        \ 'inactive': s:inactive,
        \ 'active': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.purple[0],
            \ 'guibg': s:palette.color08[0],
            \ 'ctermfg': s:palette.purple[1],
            \ 'ctermbg': s:palette.color08[1],
        \  },
        \ },
      \ 'git': {
        \ 'inactive': s:inactive,
        \ 'added': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.green[0],
            \ 'guibg': s:palette.color08[0],
            \ 'ctermfg': s:palette.green[1],
            \ 'ctermbg': s:palette.color08[1],
        \  },
        \ 'modified': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.orange[0],
            \ 'guibg': s:palette.color08[0],
            \ 'ctermfg': s:palette.orange[1],
            \ 'ctermbg': s:palette.color08[1],
        \  },
        \ 'removed': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.red[0],
            \ 'guibg': s:palette.color08[0],
            \ 'ctermfg': s:palette.red[1],
            \ 'ctermbg': s:palette.color08[1],
        \  },
        \ 'icon': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.color08[0],
            \ 'guibg': s:palette.purple[0],
            \ 'ctermfg': s:palette.color08[1],
            \ 'ctermbg': s:palette.purple[1],
        \  },
        \ },
\}

function! moline#colorscheme#dracula#init() abort
  for [cls,cls_states] in items(s:colors)
    for [state, group_cfg] in items(cls_states)
      call moline#highlight#group(cls,state,group_cfg)
    endfor
  endfor
endfunction
