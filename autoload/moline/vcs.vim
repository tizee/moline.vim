scriptencoding utf-8

function! moline#vcs#git() abort
  let [a,m,r]=s:get_git_diff_hunk()
  let remote_icon = s:get_remote_icon()
  let current_branch = s:get_branch()
  if len(current_branch)==0
    return ''
  endif
  let msg = []
  call add(msg, '%#Moline_git_added#%' . ' ' . g:moline_git_status_icons['added'].' '.trim(a))
  call add(msg, '%#Moline_git_modified#%' . ' '. g:moline_git_status_icons['modified'].' '.trim(m))
  call add(msg, '%#Moline_git_removed#%'. ' ' . g:moline_git_status_icons['removed'].' '.trim(r))
  if !empty(remote_icon)
    call add(msg, '%#Moline_git_icon#%'.' '.remote_icon)
  endif
  if winwidth(0) > 70 && !empty(current_branch)
    call add(msg, current_branch . ' ')
    return join(msg, ' ')
  endif
  return ''
endfunction

" git plugin compatibility
function! s:get_git_diff_hunk() abort
  let added = 0
  let modified= 0
  let removed = 0
  if exists('*GitGutterGetHunkSummary')
    let [added, modified, removed] = GitGutterGetHunkSummary()
  endif
  return [added, modified, removed]
endfunction

function! s:get_branch()
  if exists('*FugitiveHead')
    return FugitiveHead()
  endif
  return system('git branch --show-current') . ' '
endfunction

function! s:get_remote_icon() abort
  let url = s:get_git_repo_link('origin')
  let platform = s:get_git_platform(url)
  if has_key(g:moline_git_remote_icons, platform)
    return g:moline_git_remote_icons[platform]
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
