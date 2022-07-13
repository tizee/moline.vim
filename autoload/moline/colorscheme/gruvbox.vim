scriptencoding utf-8

" dark mode only
" [gui, cterm]
let s:palette={}
let s:palette.dark0_hard  = ['#1d2021', 234]     " 29-32-33
let s:palette.dark0       = ['#282828', 235]     " 40-40-40
let s:palette.dark0_soft  = ['#32302f', 236]     " 50-48-47
let s:palette.dark1       = ['#3c3836', 237]     " 60-56-54
let s:palette.dark2       = ['#504945', 239]     " 80-73-69
let s:palette.dark3       = ['#665c54', 241]     " 102-92-84
let s:palette.dark4       = ['#7c6f64', 243]     " 124-111-100
let s:palette.dark4_256   = ['#7c6f64', 243]     " 124-111-100

let s:palette.gray_245    = ['#928374', 245]     " 146-131-116
let s:palette.gray_244    = ['#928374', 244]     " 146-131-116

let s:palette.light0_hard = ['#f9f5d7', 230]     " 249-245-215
let s:palette.light0      = ['#fbf1c7', 229]     " 253-244-193
let s:palette.light0_soft = ['#f2e5bc', 228]     " 242-229-188
let s:palette.light1      = ['#ebdbb2', 223]     " 235-219-178
let s:palette.light2      = ['#d5c4a1', 250]     " 213-196-161
let s:palette.light3      = ['#bdae93', 248]     " 189-174-147
let s:palette.light4      = ['#a89984', 246]     " 168-153-132
let s:palette.light4_256  = ['#a89984', 246]     " 168-153-132

let s:palette.bright_red     = ['#fb4934', 167]     " 251-73-52
let s:palette.bright_green   = ['#b8bb26', 142]     " 184-187-38
let s:palette.bright_yellow  = ['#fabd2f', 214]     " 250-189-47
let s:palette.bright_blue    = ['#83a598', 109]     " 131-165-152
let s:palette.bright_purple  = ['#d3869b', 175]     " 211-134-155
let s:palette.bright_aqua    = ['#8ec07c', 108]     " 142-192-124
let s:palette.bright_orange  = ['#fe8019', 208]     " 254-128-25

let s:palette.neutral_red    = ['#cc241d', 124]     " 204-36-29
let s:palette.neutral_green  = ['#98971a', 106]     " 152-151-26
let s:palette.neutral_yellow = ['#d79921', 172]     " 215-153-33
let s:palette.neutral_blue   = ['#458588', 66]      " 69-133-136
let s:palette.neutral_purple = ['#b16286', 132]     " 177-98-134
let s:palette.neutral_aqua   = ['#689d6a', 72]      " 104-157-106
let s:palette.neutral_orange = ['#d65d0e', 166]     " 214-93-14

let s:palette.faded_red      = ['#9d0006', 88]      " 157-0-6
let s:palette.faded_green    = ['#79740e', 100]     " 121-116-14
let s:palette.faded_yellow   = ['#b57614', 136]     " 181-118-20
let s:palette.faded_blue     = ['#076678', 24]      " 7-102-120
let s:palette.faded_purple   = ['#8f3f71', 96]      " 143-63-113
let s:palette.faded_aqua     = ['#427b58', 66]      " 66-123-88
let s:palette.faded_orange   = ['#af3a03', 130]     " 175-58-3

let s:active={ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg'   : s:palette.light0_soft[0],
              \ 'guibg'   : s:palette.dark2[0],
              \ 'ctermfg' : s:palette.light0_soft[1],
              \ 'ctermbg' : s:palette.dark2[1],
              \}
let s:inactive = {
      \ 'gui'   : 'bold',
      \ 'cterm' : 'bold',
      \ 'guifg'   : s:palette.dark0[0],
      \ 'guibg'   : s:palette.dark4[0],
      \ 'ctermfg' : s:palette.dark0[1],
      \ 'ctermbg' : s:palette.dark4[1],
      \}

let s:modes={
              \ 'normal': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_blue[0],
              \ 'guifg': s:palette.light0_hard[0],
              \ 'ctermbg': s:palette.bright_blue[1],
              \ 'ctermfg': s:palette.light0_hard[1],
              \ },
              \ 'insert': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_green[0],
              \ 'guifg': s:palette.light0_hard[0],
              \ 'ctermbg': s:palette.bright_green[1],
              \ 'ctermfg': s:palette.light0_hard[1],
              \ },
              \ 'visual': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_orange[0],
              \ 'guifg': s:palette.light0_hard[0],
              \ 'ctermbg': s:palette.bright_orange[1],
              \ 'ctermfg': s:palette.light0_hard[1],
              \ },
              \ 'command': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_aqua[0],
              \ 'guifg': s:palette.light0_hard[0],
              \ 'ctermbg': s:palette.bright_aqua[1],
              \ 'ctermfg': s:palette.light0_hard[1],
              \ },
              \ 'select': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_yellow[0],
              \ 'guifg': s:palette.light0_hard[0],
              \ 'ctermbg': s:palette.bright_yellow[1],
              \ 'ctermfg': s:palette.light0_hard[1],
              \ },
              \ 'terminal': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_purple[0],
              \ 'guifg': s:palette.light0_hard[0],
              \ 'ctermbg': s:palette.bright_purple[1],
              \ 'ctermfg': s:palette.light0_hard[1],
              \ },
              \}

let s:modes_bg={}
let s:modes_bg.normal={
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_blue[0],
              \ 'guifg': s:palette.light0_soft[0],
              \ 'ctermbg': s:palette.bright_blue[1],
              \ 'ctermfg': s:palette.light0_soft[1],
      \}

let s:modes_bg.insert={
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_green[0],
              \ 'guifg': s:palette.light0_soft[0],
              \ 'ctermbg': s:palette.bright_green[1],
              \ 'ctermfg': s:palette.light0_soft[1],
              \}
let s:modes_bg.visual={
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_orange[0],
              \ 'guifg': s:palette.light0_soft[0],
              \ 'ctermbg': s:palette.bright_orange[1],
              \ 'ctermfg': s:palette.light0_soft[1],
              \ }
let s:modes_bg.command={
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_aqua[0],
              \ 'guifg': s:palette.light0_soft[0],
              \ 'ctermbg': s:palette.bright_aqua[1],
              \ 'ctermfg': s:palette.light0_soft[1],
              \ }
let s:modes_bg.select={
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_yellow[0],
              \ 'guifg': s:palette.light0_soft[0],
              \ 'ctermbg': s:palette.bright_yellow[1],
              \ 'ctermfg': s:palette.light0_soft[1],
              \ }
let s:modes_bg.terminal={
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guibg': s:palette.bright_purple[0],
              \ 'guifg': s:palette.light0_soft[0],
              \ 'ctermbg': s:palette.bright_purple[1],
              \ 'ctermfg': s:palette.light0_soft[1],
              \ }

let s:colors = {
      \ 'default': {
        \ 'inactive': s:inactive,
        \ 'active': s:active,
      \},
      \  'mode': {
              \ 'active': s:inactive,
              \ 'inactive': s:inactive,
              \ 'normal': s:modes.normal,
              \ 'insert': s:modes.insert,
              \ 'visual': s:modes.visual,
              \ 'command': s:modes["command"],
              \ 'select': s:modes["select"],
              \ 'terminal': s:modes.terminal,
      \},
      \ 'diagnostic': {
        \ 'inactive': s:inactive,
        \ 'error': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.bright_red[0],
              \ 'guibg': s:palette.dark2[0],
              \ 'ctermfg': s:palette.bright_red[1],
              \ 'ctermbg': s:palette.dark2[1],
        \   },
        \ 'warn': {
              \ 'cterm'   : 'bold',
              \ 'gui'     : 'bold',
              \ 'guifg': s:palette.bright_orange[0],
              \ 'guibg': s:palette.dark2[0],
              \ 'ctermfg': s:palette.bright_orange[1],
              \ 'ctermbg': s:palette.dark2[1],
              \ }
      \ },
      \ 'filename': {
        \ 'inactive': s:inactive,
        \ 'active': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.bright_purple[0],
            \ 'guibg': s:palette.dark2[0],
            \ 'ctermfg': s:palette.bright_purple[1],
            \ 'ctermbg': s:palette.dark2[1],
          \  },
        \ },
      \ 'git': {
        \ 'inactive': s:inactive,
        \ 'added': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.bright_green[0],
            \ 'guibg': s:palette.dark2[0],
            \ 'ctermfg': s:palette.bright_green[1],
            \ 'ctermbg': s:palette.dark2[1],
        \  },
        \ 'modified': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.bright_orange[0],
            \ 'guibg': s:palette.dark2[0],
            \ 'ctermfg': s:palette.bright_orange[1],
            \ 'ctermbg': s:palette.dark2[1],
        \  },
        \ 'removed': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.bright_red[0],
            \ 'guibg': s:palette.dark2[0],
            \ 'ctermfg': s:palette.bright_red[1],
            \ 'ctermbg': s:palette.dark2[1],
        \  },
        \ 'icon': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.dark2[0],
            \ 'guibg': s:palette.bright_purple[0],
            \ 'ctermfg': s:palette.dark2[1],
            \ 'ctermbg': s:palette.bright_purple[1],
        \  },
        \ },
      \ 'lsp': {
        \ 'inactive': s:inactive,
        \ 'active': {
            \ 'cterm'   : 'bold',
            \ 'gui'     : 'bold',
            \ 'guifg': s:palette.bright_aqua[0],
            \ 'guibg': s:palette.dark2[0],
            \ 'ctermfg': s:palette.bright_aqua[1],
            \ 'ctermbg': s:palette.dark2[1],
        \   },
      \ },
        \'fileformat':{
            \ 'inactive': s:inactive,
            \ 'active': s:inactive,
            \ 'normal': s:modes_bg.normal,
            \ 'insert': s:modes_bg.insert,
            \ 'visual': s:modes_bg.visual,
            \ 'command': s:modes_bg.command,
            \ 'select': s:modes_bg.select,
            \ 'terminal': s:modes_bg.terminal,
        \},
\}

function! moline#colorscheme#gruvbox#init() abort
  for [cls,cls_states] in items(s:colors)
    for [state, group_cfg] in items(cls_states)
      call moline#highlight#group(cls,state,group_cfg)
    endfor
  endfor
endfunction
