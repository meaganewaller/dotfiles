" source $HOME/.config/nvim/general.vimrc
" source $HOME/.config/nvim/plugins.vimrc
" source $HOME/.config/nvim/plugin-config.vimrc
" source $HOME/.config/nvim/keys.vimrc
" source $HOME/.config/nvim/theme.vimrc
set encoding=utf-8
scriptencoding utf-8

" Change the mapleader from \ to ,
let g:mapleader=","

" General Settings
set showmode                         "show which mode you're currently in (Insert, Replace, Visual)
set number                           "always show line numbers
set hidden                           "hide buffers instead of closing them
set showcmd                          "show partial command in the last line of the screen
set gcr=a:blinkon0                   "guicursor, blink on is the time that the cursor is shown
set mouse=a                          "enable the use of the mouse in all previous modes

set virtualedit=all                  "allow cursor to go into "invalid" places
set showmatch                        "show matching parens
set autoread                         "when a file was changed outside of a vim and hasn't been changed
                                     "if it's been deleted this isn't done
set nowrap                           "dont wrap lines
set backspace=indent,eol,start       "allow backspacing over everything in insert mode
set autoindent                       "always set autoindenting on
set copyindent                       "copy the previous indentation on autoindenting
set smarttab                         "insert tabs on the start of a line according to shiftwidth, not tabstop
set shiftwidth=2                     "number of spaces to use for autoindenting
set softtabstop=2                    "when hitting backspace pretend like a tab is removed, even if spaces
set tabstop=2                        "a tab is 2 spaces
set expandtab                        "expand tabs by default
set shiftround                       "use multiple of shiftwidth when indenting with '<' and '>'
set incsearch                        "show search matches as you type
set hlsearch                         "highlight search matche"
set ignorecase                       "ignore case when searching
set smartcase                        "ignore case if search pattern is all lowercase, case-sensitive otherwise
" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·
set formatoptions+=1                 "when wrapping paragraphs don't end lines with 1-letter words.
set clipboard=unnamed                "normal OS clipboard interaction
set lazyredraw                       "dont update the display while executing macros
set laststatus=2                     "tell vim to always put a status line in, even if there is only one window
set cmdheight=1                      "use a status bar that is 2 rows high
filetype plugin on
filetype indent on

" Folding
set foldenable
set foldcolumn=0
set foldmethod=indent              "detect triple { style fold markers"
set foldlevelstart=99              "start out with everything unfolded
" the commands which trigger auto-unfold
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" Vim behavior {{{
set switchbuf=useopen           "reveal always opened files from the quickfix
                                "window instead of opening new buffers
set history=10000
set undolevels=1000

" Persistent Undo
" Keep undo history across sessions, by storing in file.
" Only works all the time.
" if has('persistent_undo') && !isdirectory(expand('~').'/.config/nvim/backups')
"   silent !mkdir ~/.config/nvim/backups > /dev/null 2>&1
"   set undodir=~/.config/nvim/backups
"   set undofile
" endif

" Turn Off Swap Files
set noswapfile
set nobackup
set nowb

set wildmenu                    " make tab completion for files/buffers act like bash
set wildmode=list:full          " show a list when pressing tab and complete first full match
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                       " change the terminal's title
set visualbell                  " don't beep
set noerrorbells                " don't beep
set cursorline                  " underline the current line, for quick orientation
set nomodeline                  " disable mode lines (security measure)

" Keymappings
" RSI Preventation
" Use the middle finder of either hand you can type
" underscores with cmd-k or cmd-d, and add Shift
" to type dashes
imap <silent> <D-k> _
imap <silent> <D-d> _
imap <silent> <D-K> -
imap <silent> <D-D> -

"Move up/down quickly by using Cmd-j, Cmd-k
"which will move us around by functions
nnoremap <silent> <D-j> }
nnoremap <silent> <D-k> {
autocmd FileType ruby map <buffer> <D-j> ]m
autocmd FileType ruby map <buffer> <D-k> [m
autocmd FileType rspec map <buffer> <D-j> }
autocmd FileType rspec map <buffer> <D-k> {
autocmd FileType javascript map <buffer> <D-k> }
autocmd FileType javascript map <buffer> <D-j> {

" Use numbers to pick the tab you want
map <silent> <D-1> :tabn 1<CR>
map <silent> <D-2> :tabn 2<CR>
map <silent> <D-3> :tabn 3<CR>
map <silent> <D-4> :tabn 4<CR>
map <silent> <D-5> :tabn 5<CR>
map <silent> <D-6> :tabn 6<CR>
map <silent> <D-7> :tabn 7<CR>
map <silent> <D-8> :tabn 8<CR>
map <silent> <D-9> :tabn 9<CR>

" Resize windows with arrow keys
nnoremap <D-Up> <C-w>+
nnoremap <D-Down> <C-w>-
nnoremap <D-Left> <C-w><
nnoremap <D-Right> <C-w>><Paste>

" General Vim Sanity Improvements
" Fixing common typos
iab impressoin impression
iab variatoin variation
iab panelsit panelist

" A more handy Esc
inoremap jj <Esc>
inoremap kk <Esc>
inoremap jk <Esc>
inoremap kj <Esc>

inoremap <esc> <nop>

" Aliases yw to yank the entire word 'yank inner word'
" even if the cursor is halfway inside the word
nnoremap ,yw yiww

" ,ow = 'overwrite word', replace a word with that's in the yank buffer
nnoremap ,ow "_diwhp"

" Make Y consistent with C and D
nnoremap Y y$
function! YRRunAfterMaps()
  nnoremap Y :<C-U>YRYankCount 'y$'<CR>
endfunction

" Make 0 go to the first character rather than the beginning
" of the line. When we're programming, we're almost always
" interested in working with text rather than empty space. If
" you want the traditional beginning of line, use ^
nnoremap 0 ^
nnoremap ^ 0

" ,# Surround a word with #{ruby interpolation}
" map ,# ysiw#
" vmap ,# c#{<C-R>"}<ESC>

" ,' Surround a word with 'single quotes'
" map , ' ysiw
" vmap ,' c'<C-R>"'<ESC>

" ,) or ,( Surround a word with (parens)
" The difference is in whether a space is put in
" map ,( ysiw(
" map ,) ysiw)
" vmap ,( c( <C-R>" )<ESC>
" vmap ,) c(<C-R>")<ESC>

" ,[ Surround a word with [brackets]
" map ,] ysiw]
" map ,[ ysiw[
" vmap ,[ c[ <C-R>" ]<ESC>
" vmap ,] c[<C-R>"]<ESC>

" nnoremap J mzJ`z

"Quickly edit/reload the nvim config
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

"" Forgot to sudo before editing a file that requires it? Using w!! to do it
"" after you've opened the file.
"" cmap w!! w !sudo tee % >/dev/null
" Window/Tab/Split Manipulation
" ==============================

" Make gf (go to file) create the file, if not existent
nnoremap <C-w>f :sp +e<cfile><CR>
nnoremap <C-w>gf :tabe<cfile><CR>

" Zoom in
map <silent> ,gz <C-w>o

" Create window splits easier. The default
" way is Ctrl-w,v and Ctrl-w,s. I remap
" this to vv and ss
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" create <%= foo %> erb tags using Ctrl-k in edit mode
imap <silent> <C-K> <%=   %><Esc>3hi

" create <%= foo %> erb tags using Ctrl-j in edit mode
imap <silent> <C-J> <%  %><Esc>2hi

" Shortcuts for everyday tasks
" copy current filename into system clipboard -- mnemonic:
" (c)urrent(f)ilename
" this is helpful to paste someone the path you're looking at
nnoremap <silent> ,cf :let @* = expand("%:~")<CR>
nnoremap <silent> ,cr :let @* = expand("%")<CR>
nnoremap <silent> ,cn :let @* = expand("%:t")<CR>

"(v)im (c)ommand - execute current line as a vim command
nmap <silent> ,vc yy:<C-f>p<C-c><CR>

"(v)im (r)eload
nmap <silent> ,vr :so %<CR>

" Type ,hl to toggle highlighting on/off, and show current value.
noremap ,hl :set hlsearch! hlsearch?<CR>

" These are very similar keys. Typing 'a will jump to the line in the
" current file marked with ma. However, `a will jump to the line
" and column marked
" with ma.  It’s more useful in any case I can imagine, but it’s located way
" off in the corner of the keyboard. The best way to handle this is just to
" swap them: http://items.sjbach.com/319/configuring-vim-right
nnoremap ' `
nnoremap ` '

" ========== Plugins ==========
call plug#begin('~/.config/nvim/plugged')
" ========== Ruby =============
Plug 'ecomba/vim-ruby-refactoring'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'keith/rspec.vim'
Plug 'skwp/vim-iterm-rspec'
Plug 'skwp/vim-spec-finder'
Plug 'ck3g/vim-change-hash-syntax'
Plug 'tpope/vim-bundler'
Plug 'thoughtbot/vim-rspec'

" ========== JavaScript =======
Plug 'kchmck/vim-coffee-script'
Plug 'elzr/vim-json'
Plug 'jelera/vim-javascript-syntax'
Plug 'mxw/vim-jsx'
Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" ========== Web Dev ==========
Plug 'aaronjensen/vim-sass-status'
Plug 'cakebaker/scss-syntax.vim'
Plug 'groenewege/vim-less'
Plug 'hail2u/vim-css3-syntax'
Plug 'lukaszb/vim-web-indent'
Plug 'othree/html5.vim'
Plug 'othree/html5-syntax.vim'
Plug 'vim-scripts/html-improved-indentation'
Plug 'tpope/vim-haml'
Plug 'slim-template/vim-slim'
Plug 'mattn/emmet-vim'
Plug 'skwp/vim-html-escape'
Plug 'dsawardekar/wordpress.vim'
Plug 'shawncplus/phpcomplete.vim'
Plug 'StanAngeloff/php.vim'
Plug '2072/PHP-Indenting-for-VIm'

" ========== Utilities ========
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-commentary'
Plug 'janko-m/vim-test'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-endwise'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'thinca/vim-localrc'
Plug 'rizzatti/dash.vim'
Plug 'tpope/vim-dispatch'
Plug 'rking/ag.vim'
Plug 'grassdog/tagman.vim'
Plug 'tobyS/pdv'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'

" ========== Look =============
Plug 'chrisbra/color_highlight'
Plug 'godlygeek/csapprox'
Plug 'vim-airline/vim-airline'
Plug 'trevordmiller/nova-vim'
Plug 'davidklsn/vim-sialoquent'
Plug 'tssm/fairyfloss.vim'
Plug 'KeitaNakamura/neodark.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rakr/vim-one'
Plug 'meaganewaller/soft-era-vim'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim'

" ========== Git ==============
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" ========== Code Nav =========
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-abolish'

" ========== Vim Improvements =
Plug 'mutewinter/splitjoin.vim'
Plug 'Raimondi/delimitMate'
Plug 'briandoll/change-inside-surroundings.vim'
Plug 'vim-scripts/camelcasemotion'

call plug#end()

" Functions
" Toggle the quickfix window
" From Steve Losh,
" http://learnvimscriptthehardway.stevelosh.com/chapters/38.html
let mapleader=";"
nnoremap <C-q> :call <SID>QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! s:QuickfixToggle()
	if g:quickfix_is_open
		cclose
		let g:quickfix_is_open = 0
		execute g:quickfix_return_to_window . "wincmd w"
	else
		let g:quickfix_return_to_window =
		winnr()
		copen
		let
		g:quickfix_is_open =
		1
	endif
endfunction
let g:mapleader=","
" Delete trailing WS
" Delete trailing white space on save
func! DeleteTrailingWS()
	exe "normal mz"
	%s/\s\+$//ge
	exe "normal `z"
endfunc

au BufWrite * silent call DeleteTrailingWS()

" Plugin Settings
" Dash
:nmap <silent> <leader>d <Plug>DashSearch

" Appearance
" Highlighting
if &t_Co > 2 || has("gui_running")
  syntax on " switch syntax highlighting on, when the terminal has colors
endif
set t_Co=256
let g:CSApprox_loaded = 1
" Make it beautiful - colors and fonts
set termguicolors
if (has("termguicolors"))
  set termguicolors
endif

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
if has("gui_running")
  " tell the term has 256 colors
	set t_Co=256
	" Show tab number (useful for Cmd-1, Cmd-2.. mapping)
	" For some reason this doesn't work as a regular set command,
	" (the numbers don't show up) so I made it a VimEnter event
	autocmd VimEnter * set guitablabel=%N:\ %t\ %M
	set lines=60
	set columns=190
	if has("gui_gtk2")
		set guifont=Inconsolata\ XL\ 12,Inconsolata\ 15,Monaco\ 12
	else
		set guifont=Inconsolata\ XL:h17,Inconsolata:h20,Monaco:h17
	end
else
	let g:CSApprox_loaded = 1
endif

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
   set termguicolors
endif

" Neovim 0.1.3 or 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Enable syntax highlighting and set colorscheme
syntax enable
colorscheme dracula

let g:one_allow_italics = 1

"html indents
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "address,article,aside,audio,blockquote,canvas,dd,div,dl,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,header,hgroup,hr,main,nav,noscript,ol,output,p,pre,section,table,tfoot,ul,video"

let g:wordpress_vim_ctags_path='/usr/local/bin/ctags'
" git-gutter
let g:gitgutter_sign_modified   = '•'
let g:gitgutter_sign_added      = '▸'
highlight GitGutterAdd guifg    = '#ffea00'
highlight GitGutterChange guifg = '#ffb8d1'

" ========== Airline ==========
let g:airline#extensions#tmuxline#enabled = 1
let g:tmuxline_theme = 'dracula'
let g:airline_theme = 'dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" es6.vim
"Automatically treat .es6 extension files as javascript
" autocmd BufRead,BufNewFile *.es7 setfiletype javascript
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" Run prettier automatically on javascript and other files
" let g:prettier#autoformat = 0
" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

" fugitive
nnoremap <silent> ,dg :diffget<CR>
nnoremap <silent> ,dp :diffput<CR>

" The tree buffer makes it easy to drill down through the directories of your
" git repository, but it’s not obvious how you could go up a level to the
" parent directory. Here’s a mapping of .. to the above command, but
" only for buffers containing a git blob or tree
autocmd User fugitive
			\ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
			\   nnoremap <buffer> .. :edit %:h<CR> |
			\ endif
" Every time you open a git object using fugitive it
" creates a new buffer. This means that your buffer listing
" can quickly become swamped with
" fugitive buffers. This prevents this from becomming an issue:
autocmd BufReadPost fugitive://* set bufhidden=delete

" grep
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" CTRL P
nnoremap <leader>p :CtrlP<cr>
nnoremap <silent> <leader>r :ClearCtrlPCache<cr>
let g:ctrlp_custom_ignore =['debug[[dir]]', 'gravity[[dir]]', 'akismet[[dir]]', 'user-switching[[dir]]', 'wp-migrate-db-pro[[dir]]', 'upgrade[[dir]]', 'uploads[[dir]]', 'twenty*[[dir]]']

" phpcomplete disable Ctrl+] (was conflicting)
" see https://github.com/curtismchale/WPTT-Vim-Config/issues/62
" https://github.com/shawncplus/phpcomplete.vim/issues/48
let g:phpcomplete_enhance_jump_to_definition = 0

" PDV - PHP documenter script
" let g:pdv_template_dir = $HOME."/.vim/bundle/pdv/templates_snip"
" noremap <leader>d :call pdv#DocumentCurrentLine()<CR>

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

nnoremap <Leader>gg :Ag<SPACE>

" smart jump to tag
" hi ,f to find the definition of the current class
" this uses ctags. the standard way to get this is Ctrl-]
nnoremap <silent> ,f <C-]>

" use ,F to jump to tag in a vertical split
nnoremap <silent> ,F :let word=expand("<cword>")<CR>:vsp<CR>:wincmd w<cr>:exec("tag ". word)<cr>

" vim indent guides
let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size  = 1

" vim-tmux-navigator
" Don't allow any default key-mappings.
let g:tmux_navigator_no_mappings = 1
set t_8b=^[[48;2;%lu;%lu;%lum
set t_8f=^[[38;2;%lu;%lu;%lum

" Re-enable tmux_navigator.vim default bindings, minus <c-\>.
" <c-\> conflicts with NERDTree 'current file'
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" whitespace killer
" via: http://rails-bestpractices.com/posts/60-remove-trailing-whitespace
" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
	" Preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	%s/\s\+$//e
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction
command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
nmap ,w :StripTrailingWhitespaces<CR>

" ===== quickfix =====
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" ===== syntastic =====
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1

" Display checker-name for that error-message
let g:syntastic_aggregate_errors = 1

" I use the brew to install flake8
let g:syntastic_python_checkers=['flake8', 'python3']
"mark syntax errors with :signs
let g:syntastic_enable_signs=1
"automatically jump to the error when saving the file
let g:syntastic_auto_jump=0
"show the error list automatically
let g:syntastic_auto_loc_list=1
"don't care about warnings
let g:syntastic_quiet_messages = {'level': 'warnings'}

" Default to eslint. If you need jshint, you can override this in
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
let g:syntastic_javascript_eslint_args= ['--fix']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_python_checkers=['python', 'pep8', 'flake8', 'pyflakes']
let g:syntastic_python_flake8_post_args='--ignore=W391'

" I have no idea why this is not working, as it used to
" be a part of syntastic code but was apparently removed
" This will make syntastic find the correct ruby specified by mri
function! s:FindRubyExec()
	if executable("rvm")
		return system("rvm tools identifier")
	endif

	return "ruby"
endfunction

if !exists("g:syntastic_ruby_exec")
	let g:syntastic_ruby_exec = s:FindRubyExec()
endif

" ===== rspec.vim =====
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" ===== Modify word boundary characters =====
" remove - as a word boundary
set iskeyword+=-

" remove $ as a word boundary
set iskeyword+=$

" ===== Point to the Python executables =====
" let g:python_host_prog  = $HOME . '/.pyenv/versions/neovim2/bin/python'
" let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'

let g:ycm_autoclose_preview_window_after_completion=1
let python_highlight_all=1

nnoremap <ESC> :nohl<CR>
