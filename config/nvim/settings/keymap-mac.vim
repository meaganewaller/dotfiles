" RSI Preventation - keyboard remaps
" Certain things we do every day as programmers stress
" out our hands. For example, typing underscores and dashes
" are very common, and in position tha trequire a lot of hand movements
" Vim to the rescue.
"
" Now using the middle finger of either hand you can type
" underscores with apple-k or apple-d, and add Shift
" to type dashes
" imap <silent> <D-k> _
" imap <silent> <D-d> _
" imap <silent> <D-K> _
" imap <silent> <D-D> -

" Change inside various enclosures with Cmd-" and Cmd-'
" The f makes it find the enclosure so you don't have
" to be standing inside it
" nnoremap <D-'> f'ci'
" nnoremap <D-"> f"ci"
" nnoremap <D-(> f(ci(
" nnoremap <D-)> f)ci)
" nnoremap <D-[> f[ci[
" nnoremap <D-]> f]ci]

"Move up/down quickly by using Cmd-j, Cmd-k
"which will move us around by functions
" nnoremap <silent> <D-j> }
" nnoremap <silent> <D-k> {
" autocmd FileType ruby map <buffer> <D-j> ]m
" autocmd FileType ruby map <buffer> <D-k> [m
" autocmd FileType rspec map <buffer> <D-j> }
" autocmd FileType rspec map <buffer> <D-k> {
" autocmd FileType javascript map <buffer> <D-k> }
" autocmd FileType javascript map <buffer> <D-j> {

"Use numbers to pick the tab you want
" map <silent> <D-1> :tabn 1<CR>
" map <silent> <D-2> :tabn 2<CR>
" map <silent> <D-3> :tabn 3<CR>
" map <silent> <D-4> :tabn 4<CR>
" map <silent> <D-5> :tabn 5<CR>
" map <silent> <D-6> :tabn 6<CR>
" map <silent> <D-7> :tabn 7<CR>
" map <silent> <D-8> :tabn 8<CR>
" map <silent> <D-9> :tabn 9<CR>

"Resize windows with arrow keys
" nnoremap <D-Up> <C-w>+
" nnoremap <D-Down> <C-w>-
" nnoremap <D-Left> <C-w><
" nnoremap <D-Right> <C-w>>

" General Vim Sanity Improvements
" Aliases yw to yank the entire word 'yank inner word'
" even if the cursor is halfway inside the word
" nnoremap ,yw yiww

" ,ow = 'overwrite word', replace a word with that's in the yank buffer
" nnoremap ,ow "_diwhp

" Make Y consistent with C and D
nnoremap Y y$
function! YRRunAfterMaps()
  nnoremap Y :<C-U>YRYankCount 'y$'<CR>
endfunction

"Make 0 go to the first character rather than the beginning
"of the line. When we're programming, we're almost always
"interested in working with text rather than empty space. If
"you want the traditional beginning of line, use ^
nnoremap 0 ^
nnoremap ^ 0

" ,# Surround a word with #{ruby interpolation}
map ,# ysiw#
vmap ,# c#{<C-R>"}<ESC>

" ,' Surround a word with 'single quotes'
map , ' ysiw
vmap ,' c'<C-R>"'<ESC>

" ,) or ,( Surround a word with (parens)
" The difference is in whether a space is put in
map ,( ysiw(
map ,) ysiw)
vmap ,( c( <C-R>" )<ESC>
vmap ,) c(<C-R>")<ESC>

" ,[ Surround a word with [brackets]
map ,] ysiw]
map ,[ ysiw[
vmap ,[ c[ <C-R>" ]<ESC>
vmap ,] c[<C-R>"]<ESC>

" ,{ Surround a word with {braces}
map ,} ysiw}
map ,{ ysiw{
vmap ,} c{ <C-R>" }<ESC>
vmap ,{ c{<C-R>"}<ESC>

map ,` ysiw`

" gary bernhardt's hashrocket
" in insert mode, ctrl + l
imap <c-l> <space>=><space>

"Go to last edit location with ,.
nnoremap ,. '.

"When typing a string, your quotes auto complete. Move past the quote
"while still in insert mode by hitting Ctrl-a. Example:
"
" type 'foo<c-a>
"
" the first quote will autoclose so you'll get 'foo' and hitting <c-a> will
" put the cursor right after the quote
imap <C-a> <esc>wa

" ,q to toggle quickfix window (where you have stuff like Ag)
" ,oq to open it back up (rare)
nmap <silent> ,qc :cclose<CR>
nmap <silent> ,qo :copen<CR>

"Move back and forth through previous and next buffers
"with ,z and ,x
nnoremap <silent> ,z :bp<CR>
nnoremap <silent> ,x :bn<CR>

" Window/Tab/Split Manipulation
" ==============================
" Move between split windows by using the four directions H, L, K, J
" NOTE: This has moved to vim/settings/vim-tmux-navigator.vim.
" nnoremap <silent> <C-h> <C-w>h
" nnoremap <silent> <C-l> <C-w>l
" nnoremap <silent> <C-k> <C-w>k
" nnoremap <silent> <C-j> <C-w>j
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
" ============================
" copy current filename into system clipboard - mnemonic:
" (c)urrent(f)ilename
" this is helpful to paste someone the path you're looking at
nnoremap <silent> ,cf :let @* = expand("%:~")<CR>
nnoremap <silent> ,cr :let @* = expand("%")<CR>
nnoremap <silent> ,cn :let @* = expand("%:t")<CR>

"Clear current search highlight by double tapping //
nmap <silent> // :nohlsearch<CR>
"(v)im (c)ommand - execute current line as a vim command
nmap <silent> ,vc yy:<C-f>p<C-c><CR>
"(v)im (r)eload
nmap <silent> ,vr :so %<CR>
" Type ,hl to toggle highlighting on/off, and show current value.
noremap ,hl :set hlsearch! hlsearch?<CR>
" These are very similar keys. Typing 'a will jump to the line in the current
" file marked with ma. However, `a will jump to the line and column marked
" with ma.  It’s more useful in any case I can imagine, but it’s located way
" off in the corner of the keyboard. The best way to handle this is just to
" swap them: http://items.sjbach.com/319/configuring-vim-right
nnoremap ' `
nnoremap ` '

" SplitJoin plugin
" ============================
"nmap sj :SplitjoinSplit<cr>
"nmap sk :SplitjoinJoin<cr>
" Get the current highlight group. Useful for then remapping the color
"map ,hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" ".synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" .synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>
" ,hp = html preview
"map <silent> ,hp :!open -a Safari %<CR><CR>
" Map Ctrl-x and Ctrl-z to navigate the quickfix error list (normally :cnand" :cp)
"nnoremap <silent> <C-x> :cn<CR>
"nnoremap <silent> <C-z> :cp<CR>