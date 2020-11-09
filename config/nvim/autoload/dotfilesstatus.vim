scriptencoding utf-8

" ============================================================================
" Utility
" ============================================================================

" @return {String}
function! dotfilesstatus#IsNonFile() abort
  return getbufvar(s:bufnr, '&buftype') =~# '\v(nofile|quickfix|terminal)'
endfunction

" @return {String}
function! dotfilesstatus#IsHelp() abort
  return getbufvar(s:bufnr, '&buftype') =~# '\v(help)'
endfunction

" ============================================================================
" Status line
" ============================================================================

" Called by autocmd in vimrc, refresh statusline in each window
function! dotfilesstatus#Refresh() abort
  for l:winnr in range(1, winnr('$'))
    let l:fn = '%!dotfilesstatus#Output(' . l:winnr . ')'
    call setwinvar(l:winnr, '&statusline', l:fn)
  endfor
endfunction

" a:winnr from dotfilesstatus#Refresh() or 0 on set statusline
function! dotfilesstatus#Output(winnr) abort
  let s:winnr = a:winnr
  let s:bufnr = winbufnr(a:winnr)
  let s:ww    = winwidth(a:winnr)
  let l:contents = ''

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= '%#TabLine# ' . dotfilesstatus#Mode()

  " Filebased
  "let l:contents .= '%h%q%w'     " [help][Quickfix/Location List][Preview]
  let l:contents .= '%#StatusLine#' . dotfilesstatus#Filetype()
  let l:contents .= '%#PmenuSel#' . dotfilesstatus#Filename()
  let l:contents .= '%#Todo#' . dotfilesstatus#Dirty()
  let l:contents .= '%#StatusLine#' . dotfilesstatus#GitBranch()

  " Toggleable
  let l:contents .= '%#DiffText#' . dotfilesstatus#Paste()
  let l:contents .= '%#Error#' . dotfilesstatus#Readonly()

  " Temporary
  let l:contents .= '%#NeomakeErrorSign#'
        \. dotfilesstatus#Neomake('E', dotfilesstatus#NeomakeCounts())
  let l:contents .= '%#NeomakeWarningSign#'
        \. dotfilesstatus#Neomake('W', dotfilesstatus#NeomakeCounts())

  " Search context
  let l:contents .= '%#Search#' . dotfilesstatus#Anzu()

  " ==========================================================================
  " Right side
  " ==========================================================================

  " Instance context
  let l:contents .= '%*%='
  let l:contents .= '%#TermCursor#' . dotfilesstatus#GutentagsStatus()
  let l:contents .= '%#TermCursor#' . dotfilesstatus#NeomakeJobs()
  let l:contents .= '%<'
  let l:contents .= '%#PmenuSel#' . dotfilesstatus#ShortPath()
  let l:contents .= '%#TabLine#' . dotfilesstatus#Ruler()

  return l:contents
endfunction

" @return {String}
function! dotfilesstatus#Mode() abort
  " blacklist
  let l:modecolor = '%#TabLine#'
  let l:modeflag = mode()
  if l:modeflag ==# 'i'
    let l:modecolor = '%#PmenuSel#'
  elseif l:modeflag ==# 'R'
    let l:modecolor = '%#DiffDelete#'
  elseif l:modeflag =~? 'v'
    let l:modecolor = '%#Cursor#'
  elseif l:modeflag ==? "\<C-v>"
    let l:modecolor = '%#Cursor#'
    let l:modeflag = 'B'
  endif
  return  l:modecolor . ' ' . l:modeflag . ' '
endfunction

" @return {String}
function! dotfilesstatus#Paste() abort
  return s:winnr != winnr() || empty(&paste)
        \ ? ''
        \ : ' ᴘ '
endfunction

" @return {String}
function! dotfilesstatus#Neomake(key, counts) abort
  let l:e = get(a:counts, a:key, 0)
  return l:e ? ' ⚑' . l:e . ' ' : ''
endfunction

" @return {String}
function! dotfilesstatus#NeomakeCounts() abort
  return s:winnr != winnr()
        \ || !exists('*neomake#statusline#LoclistCounts')
        \ ? {}
        \ : neomake#statusline#LoclistCounts()
endfunction

" @return {String}
function! dotfilesstatus#NeomakeJobs() abort
  return s:winnr != winnr()
        \ || !dotfiles#IsPlugged('neomake')
        \ || !exists('*neomake#GetJobs')
        \ || empty(neomake#GetJobs())
        \ ? ''
        \ : ' ᴍᴀᴋᴇ '
endfunction

" @return {String}
function! dotfilesstatus#Readonly() abort
  return getbufvar(s:bufnr, '&readonly') ? ' ʀ ' : ''
endfunction

" @return {String}
function! dotfilesstatus#Filetype() abort
  let l:ft = getbufvar(s:bufnr, '&filetype')
  return empty(l:ft)
        \ ? ''
        \ : ' ' . l:ft . ' '
endfunction

" @return {String}
function! dotfilesstatus#Filename() abort
  if dotfilesstatus#IsNonFile()
    return ''
  endif

  let l:contents = ' %.64f'
  let l:contents .= isdirectory(expand('%:p')) ? '/ ' : ' '
  return l:contents
endfunction

" @return {String}
function! dotfilesstatus#Dirty() abort
  return getbufvar(s:bufnr, '&modified') ? ' + ' : ''
endfunction

" @return {String}
function! dotfilesstatus#Anzu() abort
  if s:winnr != winnr() || !exists('*anzu#search_status')
    return ''
  endif

  let l:anzu = anzu#search_status()
  return empty(l:anzu)
        \ ? ''
        \ : ' ' . l:anzu . ' '
endfunction

" @return {String}
function! dotfilesstatus#ShortPath() abort
  if s:ww < 80
        \ || dotfilesstatus#IsNonFile()
        \ || dotfilesstatus#IsHelp()
    return ''
  endif

  let l:full = fnamemodify(getcwd(), ':~:.')
  return len(l:full) > s:ww
        \ ? ''
        \ : ' ' . (len(l:full) == 0 ? '~' : l:full) . ' '
endfunction

" Uses fugitive or gita to get cached branch name
"
" @return {String}
function! dotfilesstatus#GitBranch() abort
  return s:ww < 80 || s:winnr != winnr()
        \ || dotfilesstatus#IsNonFile()
        \ || dotfilesstatus#IsHelp()
        \ ? ''
        \ : exists('*fugitive#head')
        \   ? ' ' . fugitive#head(7) . ' '
        \   : exists('g:gita#debug')
        \     ? gita#statusline#format('%lb')
        \     : ''
endfunction

" @return {String}
function! dotfilesstatus#GutentagsStatus() abort
  return s:winnr != winnr() || !exists('g:loaded_gutentags')
        \ ? ''
        \ : '%{gutentags#statusline(" ᴛᴀɢ ")}'
endfunction

" @return {String}
function! dotfilesstatus#Ruler() abort
  return ' %5.(%c%) '
endfunction
