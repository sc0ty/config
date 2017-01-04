" Window font and size
set guifont=DejaVu\ Sans\ Mono\ 9
set lines=48 columns=160

" Copy and paste mappings
map <C-V>	"+gP
vmap <C-C>	"+y
imap <C-V>	<C-R>+
cmap <C-V>	<C-R>+

map <S-Insert>	"*gP
imap <S-Insert>	<C-R>*
cmap <S-Insert>	<C-R>*

" Cursor
set guicursor=a:block-Cursor
set guicursor+=i:hor10
set guicursor+=a:blinkwait0
