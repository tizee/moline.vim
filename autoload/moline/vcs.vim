let s:default_remote_icons = {
      \ 'github':  '  ',
      \ 'gitlab':  '  ',
      \ 'default': '  ',
      \}

let s:default_git_status_icons = {
      \ 'added': '',
      \ 'modified': '柳',
      \ 'removed': '',
      \}


let s:git_init=1 " 1: init 2: init done

function! s:cache_git()
  if s:git_init==1
    let s:git_status_icons=deepcopy(get(g:,'moline_git_status_icons',{}))
    for [key,val] in items(s:default_git_status_icons)
      if !has_key(s:git_status_icons,key)
        let s:git_status_icons[key]=val
      endif
    endfor
    let s:git_remote_icons=deepcopy(get(g:,'moline_git_remote_icons',{}))
    for [key,val] in items(s:default_remote_icons)
      if !has_key(s:git_remote_icons,key)
        let s:git_remote_icons[key]=val
      endif
    endfor
    let s:git_init=0
  endif 
endfunction

function! moline#vcs#git() abort
  if s:git_init==1
    call s:cache_git()
  endif 
  let [a,m,r]=s:get_git_diff_hunk()
  let remote_icon = s:get_remote_icon()
  let current_branch = s:get_branch()
  let msg = []
  if a > 0
    call add(msg, '%#Moline_git_added#%' . ' ' s:git_status_icons['added'] . ' ' . a)
  endif
  if m > 0
    call add(msg, '%#Moline_git_modified#%' . ' '. s:git_status_icons['modified'] . ' ' . m)
  endif
  if r > 0
    call add(msg, '%#Moline_git_removed#%'. ' '. s:git_status_icons['removed'] . ' ' . r)
  endif 
  if len(remote_icon) > 0
    call add(msg, '%#Moline_git_icon#%' . ' '. remote_icon)
  endif
  if winwidth(0) > 80
    call add(msg, current_branch)
  endif 
  return join(msg, ' ')
endfunction

" git plugin compatibility
function! s:get_git_diff_hunk() abort
  let added = 0
  let modified= 0
  let removed = 0
  if exists('*GitGutterGetHunkSummary')
    let[added, modified, removed] = GitGutterGetHunkSummary()
  endif 
  return [added, modified, removed]
endfunction

function! s:get_branch()
  if exists('*FugitiveHead')
    return FugitiveHead() 
  endif 
  return system('git branch --show-current')
endfunction

function! s:get_remote_icon() abort
  let url = s:get_git_repo_link('origin')
  let platform = s:get_git_platform(url)
  if has_key(s:git_remote_icons, platform)
    return s:git_remote_icons[platform]
  endif 
  return ''
endfunction

function! s:get_git_platform(url)
  if match(a:url,'github') >= 0
    return 'github'
  elseif match(a:url,'gitlab') >= 0
    return 'gitlab'
  else
    return 'default'
  endif 
endfunction

function! s:get_git_repo_link(remote) abort
  if exists('*FugitiveRemoteUrl')
    return FugitiveRemoteUrl()
  endif 
  return system("git config --get remote.". a:remote . ".url")
endfunction


" vim: set nofoldenable
