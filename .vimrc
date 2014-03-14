" based on:
" https://github.com/maciakl/.vim
" https://github.com/proteansec/dotfiles-vim/blob/master/.vimrc

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

" toggle paste mode (to paste properly indented text)
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

nnoremap <F3> :tabp<CR>
nnoremap <F4> :tabn<CR>
nnoremap <F6> :tabe<CR>
nnoremap <F5> :NERDTreeToggle<CR>
map <F7> :buffers<CR>:buffer<SPACE>
map <F8> :!/bin/bash<CR><CR>
map <F9> :make!<CR>

" build tags with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q --exclude=*.vim --exclude=tags --exclude=*.htm --exclude=*.html .<CR>
"
" normally <C-l> clears and redraws the screen, but here we're adding the
" disabling of the yellow search highlighting (the :noh command)
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" Move cursor to desired viewport with alt + left|right|up|down
nnoremap <A-Left>	<C-W>h<CR>
nnoremap <A-Right>	<C-W>l<CR>
nnoremap <A-Up>  	<C-W>k<CR>
nnoremap <A-Down>	<C-W>j<CR>

" Move tabs with alt + shift + left|right
nnoremap <silent> <A-S-Left>  :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-S-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

set clipboard=unnamed

"============= Buffers =============

" buffers can exist in background without being in a window
set hidden

" Automatically save before commands like :next and :make
set autowrite

" buffer browsing
"nnoremap <Left> :bprev<CR>
"nnoremap <Right> :bnext<CR>
" show buffer list
" jump to previous buffer
"nnoremap <Down> <C-^>

" Alt Tab to cycle through buffers
"nnoremap <Tab> :bnext<CR>

"============ Saving and Closing ============

" changing file types:
command! DOS set ff=dos 	" force windows style line endings
command! UNIX set ff=unix 	" force unix style line endings
command! MAC set ff=mac 	" force mac style line endings

" This will display the path of the current file in the status line
" It will also copy the path to the unnamed register so it can be pasted
" with p or C-r C-r
command! FILEPATH call g:getFilePath()

function! g:getFilePath()
    let @" = expand("%:p")
    echom "Current file:" expand("%:p")
endfunc

"============= Spell Check =============

"set spell 		"enable in-line spell check
"set spelllang=en

"============= Line Numbers =============

set nu		" absolute line numbers
"set cul		" highlight cursor line 
set nopaste	" pasting with auto-indent disabled (breaks bindings in cli vim)

"============= Scrolling & Position Tweaks =============

set scrolloff=3	" 3 line offset when scrolling

"============= Formatting, Indentation & Behavior =============

" enable soft word wrap
set formatoptions=l
set lbr

" use hard tabs for indentation
set tabstop=4
set softtabstop=4 	" makes backspace treat 4 spaces like a tab
set shiftwidth=4    " makes indents 4 spaces wide as well
"set expandtab 		" actually, expand tabs into spaces
set noexpandtab 	" don't expand tabs to spaces (cause fuck that)

set backspace=indent,eol,start

"============= Search & Matching =============

set showcmd			" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching

set incsearch		" incremental search
set hlsearch		" highlights searches

set noerrorbells 	" suppress audible bell
set novisualbell 	" suppress bell blink

"============= History =============

" save more in undo history
set history=1000000
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

set autoindent 		" always indent
set copyindent 		" copy previous indent on autoindenting
set smartindent

set backspace=indent,eol,start 	" backspace over everything in insert mode

" ============== Status Line ==============

set ls=2 			" Always show status line
set laststatus=2

set statusline=								 " clear the statusline for when vimrc is reloaded
set statusline+=[%n]\                        " buffer number
set statusline+=%f\                          " file name
set statusline+=%#error#%h%m%r%w%*           " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
"set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%-14.(%l/%L,%c%)\ %<%P        " offset

"============== Folding ==============

set nofoldenable 	" screw folding

"set foldmethod=indent
"set foldnestmax=3
"set foldenable

"============== Completion ==============

set wildmenu
set wildmode=list:longest
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,*.obj,*~

" longer more descriptive auto-complete prompts
set completeopt=longest,menuone
set ofu=syntaxcomplete#Complete

" OmniCppComplete
let OmniCpp_SelectFirstItem= 2

let OmniCpp_NamespaceSearch = 2
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowScopeInAbbr = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
"let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
"let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" OmniComplete after CTRL+SPACE
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
    
let g:SuperTabMappingTabLiteral = '<tab>'
let g:SuperTabMappingForward = '<c-space>'
let g:SuperTabMappingBackward = '<s-c-space>'

imap <nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-p>")<cr>

"============== NERDTree ================

let NERDTreeQuitOnOpen = 1

" lynx-like motion
let NERDTreeMapPreview		= '<Right>'
let NERDTreeMapActivateNode	= '<Right>'
let NERDTreeMapCloseDir		= '<Left>'
let NERDTreeMapUpdir		= '<Left>'

"============== Swap Files ==============

set noswapfile 		" suppress creation of swap files
set nobackup 		" suppress creation of backup files
set nowb 			" suppress creation of ~ files

"============== Filetypes ==============

" type detection for JSON files (makes snippets work)
au! BufRead,BufNewFile *.json set filetype=json 

" force txt files to be highlighted as html
au BufRead,BufNewFile *.txt setfiletype html

" Fix HTML indenting quirk as per http://bit.ly/XnlHJz
autocmd FileType html setlocal indentkeys-=*<Return>

" force php files to be treated as php/html - necessary for snipmate to work
"au BufRead,BufNewFile *.php set filetype=php.html

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

"============== Colors =================

colorscheme default
highlight clear
set background=dark
"highlight Comment		ctermfg=lightblue
highlight ModeMsg		ctermbg=blue
highlight TabLine		ctermfg=black ctermbg=white
highlight TabLineSel	ctermfg=white ctermbg=blue

highlight StatusLine	ctermfg=white ctermbg=black
highlight StatusLineNC	ctermfg=gray  ctermbg=black

" OmniComplete menu
highlight Pmenu         ctermfg=white ctermbg=blue		" menu element
highlight PmenuSel      ctermfg=white ctermbg=red		" selected element
highlight PmenuSbar     ctermfg=white ctermbg=white		" bg - scrollbar background
highlight PmenuThumb    ctermfg=red   ctermbg=white		" fg - scrollbar scrolling element

" NERDTree
highlight Directory		ctermfg=lightblue

" screen keys correction
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

