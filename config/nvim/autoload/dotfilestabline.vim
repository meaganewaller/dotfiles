scriptencoding utf-8

" ============================================================================
" Tab line
" ============================================================================

" bound to <F11> - see plugin/mappings.vim
function! dotfilestabline#Toggle() abort
  execute 'set showtabline=' . (&showtabline ? 0 : 2)
endfunction

" Called by autocmd in vimrc on cursormoved and other win events
function! dotfilestabline#Refresh() abort
  call setwinvar(winnr(), '&tabline', '%!dotfilestabline#Output()')
endfunction

" Called by autocmd in vimrc
function! dotfilestabline#Output() abort
  let l:contents = '%#StatusLine#'

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:funcinfo = dotfilescode#GetFunctionInfo()
  let l:contents .= !empty(l:funcinfo.name)
        \ ? ' %#PMenu# ' . l:funcinfo.name . ' '
        \ : ''
  " end of tab is showing a tab info
  "let l:contents .= '%#StatusLine#%T'

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%#StatusLine# %= '

  " ==========================================================================

  return l:contents
endfunction
