" based on:
" https://github.com/maciakl/.vim
" https://github.com/proteansec/dotfiles-vim/blob/master/.vimrc

"========= General settings ========

set nocompatible
set ttyfast


"============= Vundle ==============

filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" === Plugins ===
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'moll/vim-bbye'
Plugin 'kien/ctrlp.vim'
Plugin 'bogado/file-line'
Plugin 'jszakmeister/vim-togglecursor'
Plugin 'mh21/errormarker.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'leafgarland/typescript-vim'
Plugin 'mxw/vim-jsx'
Plugin 'sjl/gundo.vim'
call vundle#end()

filetype plugin indent on

"============= Mouse ==============
"
" Enable mouse usage (all modes) in terminals
set mouse=ni
set mousemodel=popup
if has("mouse_sgr")
	set ttymouse=sgr
else
	set ttymouse=xterm2
end

"============= Key Mappings =============

" press ; to issue commands in normal mode (no more shift holding)
nnoremap ; :

" press ',' and shift+',' to repeat last f/t forward and backward
nnoremap , ;
nnoremap < ,

" toggle paste mode (to paste properly indented text)
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

nnoremap <F3> :YcmCompleter GoToDefinition<CR>
nnoremap <F4> :YcmCompleter GoToDeclaration<CR>
nnoremap <F6> :tabe<CR>
nnoremap <F5> :NERDTreeToggle<CR>
nnoremap <F6> :CtrlPBuffer<CR>
nnoremap <F7> :buffers<CR>:b
nnoremap <F9> :make!<CR>
nnoremap <C-F9> :make clean<CR>
nnoremap <S-F9> :make clean<CR>

" build tags with Ctrl-F12
nnoremap <F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q '--exclude=*.vim' --exclude=tags '--exclude=*.htm' '--exclude=*.html' .<CR>

" buffers binding
nnoremap <leader>t :enew<CR>
nnoremap <C-j> :tabp<CR>
nnoremap <C-k> :tabn<CR>

" normally <C-l> clears and redraws the screen, but here we're adding the
" disabling of the yellow search highlighting (the :noh command)
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" Move cursor to desired viewport with Ctrl + arrows and Alt + arrows
nnoremap <C-Left>	<C-W>h
nnoremap <C-Right>	<C-W>l
nnoremap <C-Up>		<C-W>k
nnoremap <C-Down>	<C-W>j
nnoremap <M-Left>	<C-W>h
nnoremap <M-Right>	<C-W>l
nnoremap <M-Up>		<C-W>k
nnoremap <M-Down>	<C-W>j

" Move tabs with alt + shift + left|right
nnoremap <silent> <A-S-Left>  :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-S-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

" grep with \g... commands
nnoremap <leader>gg :execute "grep! -R " . shellescape(expand("<cword>")) . " ."<cr>:copen<cr>
nnoremap <leader>gi :execute "grep! -R " . shellescape(expand("<cword>")) . " ."<cr>:copen<cr>

" navigate quickfix window with shift + arrows
nnoremap <S-Up> :cprev<CR>
nnoremap <S-Down> :cnext<CR>
nnoremap <S-Right> :cwindow<CR>
nnoremap <S-Left> :cclose<CR>

nnoremap <C-S-Left> <C-w>v
nnoremap <C-S-Right> <C-w>v<C-w>l
nnoremap <C-S-Up> <C-w>s
nnoremap <C-S-Down> <C-w>s<C-w>k

nnoremap <leader>u :GundoToggle<CR>

if exists('$TMUX')
	nnoremap K :!tmux split-window -h man <cword><CR><CR>
endif

" Mappings in insert mode
imap <F3> <Esc><F3>
imap <F4> <Esc><F4>
imap <F5> <Esc><F5>
imap <F6> <Esc><F6>
imap <F7> <Esc><F7>
imap <F9> <Esc><F9>
imap <C-F9> <Esc><C-F9>
imap <S-F9> <Esc><S-F9>
imap <C-Left>	<Esc><C-Left>
imap <C-Right>	<Esc><C-Right>
imap <C-Up>		<Esc><C-Up>
imap <C-Down>	<Esc><C-Down>
imap <M-Left>	<Esc><M-Left>
imap <M-Right>	<Esc><M-Right>
imap <M-Up>		<Esc><M-Up>
imap <M-Down>	<Esc><M-Down>
imap <C-j> <Esc><C-j>
imap <C-k> <Esc><C-k>
imap <C-S-Left> <Esc><C-S-Left>
imap <C-S-Right> <Esc><C-S-Right>
imap <C-S-Up> <Esc><C-S-Up>
imap <C-S-Down> <Esc><C-S-Down>

set clipboard=unnamed

set ttimeoutlen=10

"============= Buffers =============

" buffers can exist in background without being in a window
set hidden

" Automatically save before commands like :next and :make
set autowrite

"============ Saving and Closing ============

" changing file types:
command! DOS set ff=dos		" force windows style line endings
command! UNIX set ff=unix	" force unix style line endings
command! MAC set ff=mac		" force mac style line endings

"============= Spell Check =============

"set spell		"enable in-line spell check
"set spelllang=en

"============= Line Numbers and Cursor =============

set nu		" absolute line numbers
set cul		" highlight cursor line
set nopaste	" pasting with auto-indent disabled (breaks bindings in cli vim)
"
" highlight column past 80
"if exists('+colorcolumn')
"	execute "set colorcolumn=" . join(range(81,299), ',')
"endif

let g:togglecursor_default = 'block'
let g:togglecursor_insert = 'underline'

"============= Scrolling & Position Tweaks =============

set scrolloff=3	" 3 line offset when scrolling

"============= Formatting, Indentation & Behavior =============

" enable soft word wrap
set formatoptions=l
set lbr

" use hard tabs for indentation
set tabstop=4
set softtabstop=4	" makes backspace treat 4 spaces like a tab
set shiftwidth=4    " makes indents 4 spaces wide as well
"set expandtab		" actually, expand tabs into spaces
set noexpandtab		" don't expand tabs to spaces (cause fuck that)

set backspace=indent,eol,start

set listchars=tab:>-,trail:~,extends:>,precedes:<

set virtualedit=block

"============= Search & Matching =============

set showcmd			" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching

set incsearch		" incremental search
set hlsearch		" highlights searches
set gdefault		" search with /g flag default on

set noerrorbells	" suppress audible bell
set novisualbell	" suppress bell blink

"============= History =============

" save more in undo history
set history=10000
set undolevels=1000000

if v:version >= 703
	set undofile        " keep a persistent backup file
	set undodir=$TEMP
endif


"=========== Syntax Highlighting & Indents ==============
syntax on
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

au BufRead,BufNewFile *.bb* set filetype=make		" bitbake
au BufRead,BufNewFile *.md  set filetype=markdown	" github readmes
au BufRead,BufNewFile *.jsx set filetype=typescript.jsx

"let g:jsx_ext_required = 0

set autoindent		" always indent
set copyindent		" copy previous indent on autoindenting
set smartindent

" ============== Status Line and title ==============

set ls=2			" Always show status line
set laststatus=2

set statusline=								 " clear the statusline for when vimrc is reloaded
set statusline+=[%n]\                        " buffer number
set statusline+=%f\                          " file name
set statusline+=%#Todo#%h%r%#Error#%m%*      " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%-14.(%l/%L,%c%)\ %<%P        " offset

set titlestring=[vim]\ %f

let g:airline_left_sep = ''
let g:airline_right_sep = ''


function! SetTmuxWindowName()
	set t_IS=k
	set t_IE=\
	set iconstring=%f
endfunction

function! ResetTmuxWindowName()
	set t_IS=
	set t_IE=
	set iconstring=vim
	silent call system("tmux setw automatic-rename")
endfunction

" show buffer file name as tmux window name
if exists('$TMUX')
	call SetTmuxWindowName()
	set icon
	autocmd VimLeave * call ResetTmuxWindowName()
	nnoremap <silent> <C-z> :call ResetTmuxWindowName()<CR><C-z>:call SetTmuxWindowName()<CR>
endif

"============== Folding ==============

set nofoldenable	" screw folding

"set foldmethod=indent
"set foldnestmax=3
"set foldenable

"============== Completion ==============

set wildmenu
set wildmode=list:longest
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,*.obj,*~,*/node_modules/*,*/.git/*

" longer more descriptive auto-complete prompts
set completeopt=longest,menuone
set ofu=syntaxcomplete#Complete

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_conf/fallback_extra_conf.py'
let g:ycm_extra_conf_vim_data = ['&filetype']
let g:ycm_error_symbol = '~E'
let g:ycm_warning_symbol = '~W'
let g:ycm_enable_diagnostic_highlighting = 0


"============= cscope/ctags =============

set cscopetag
set csto=0			" search cscope before ctags
set cscopeverbose

"============== NERDTree ================

let NERDTreeQuitOnOpen = 1
let NERDTreeDirArrows = 0

" lynx-like motion
let NERDTreeMapPreview		= '<Right>'
let NERDTreeMapActivateNode	= '<Right>'
let NERDTreeMapCloseDir		= '<Left>'
let NERDTreeMapUpdir		= '<Left>'

"================ CtrlP =================
"
let g:ctrlp_working_path_mode = 'a'

"=============== markers ================

let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat
let errormarker_errortextgroup = "ErrorMsg"
let errormarker_warningtextgroup = "WarningMsg"
let errormarker_errorgroup = ""
let errormarker_warninggroup = ""

"============== Swap Files ==============

set noswapfile		" suppress creation of swap files
set nobackup		" suppress creation of backup files
set nowb			" suppress creation of ~ files

"============== Colors =================

highlight clear
set background=dark
let g:badwolf_tabline=3
colorscheme badwolf2

hi link YcmErrorSign ErrorMsg
hi link YcmWarningSign WarningMsg

let g:airline_theme = 'cooler'


" screen keys correction
if &term =~ '^screen' || &term =~ '^st'
	" tmux will send xterm-style keys when its xterm-keys option is on
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
	execute "set <F9>=\e[20;*~"
endif

