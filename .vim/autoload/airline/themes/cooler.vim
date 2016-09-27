let g:airline#themes#cooler#palette = {}

if has("gui_running") || &t_Co >= 256

	" NORMAL
	let s:N1 = [ '#000000' , '#E4E4E4' , 'black' , 'white' ]
	let s:N2 = [ '#E4E4E4' , '#0087AF' , 'black' , 'darkcyan' ]
	let s:N3 = [ '#EEEEEE' , '#005F87' , 'white' , 'darkblue' ]

	" INSERT & REPLACE
	let s:I1 = s:N1
	let s:I2 = [ '#E4E4E4' , '#AF2800' , 188 , 124 ]
	let s:I3 = [ '#EEEEEE' , '#872800' , 231 , 88  ]

	" VISUAL
	let s:V1 = s:N1
	let s:V2 = [ '#E4E4E4' , '#AF5F00' , 188 , 130 ]
	let s:V3 = [ '#EEEEEE' , '#875300' , 231 , 94  ]

	" INACTIVE
	let s:A1 = [ '#585858' , '#E4E4E4' , 59  , 188 ]
	let s:A2 = [ '#E4E4E4' , '#466D79' , 188 , 60  ]
	let s:A3 = [ '#EEEEEE' , '#324E59' , 231 , 59  ]

	let s:CP1 = [ '#E4E4E4' , '#00AFA2' , 188 , 37 ]
	let s:CP2 = [ '#EEEEEE' , '#008787' , 231 , 30 ]
	let s:CP3 = [ '#585858' , '#E4E4E4' , 59 , 188 ]

else

	" NORMAL
	let s:N1 = [ 'black' , 'white'    , 'black' , 'white' ]
	let s:N2 = [ 'white' , 'darkcyan' , 'black' , 'cyan'  ]
	let s:N3 = [ 'white' , 'darkblue' , 'white' , 'blue'  ]

	" INSERT & REPLACE
	let s:I1 = s:N1
	let s:I2 = [ 'white' , 'red'     , 'white' , 'magenta' ]
	let s:I3 = [ 'white' , 'darkred' , 'white' , 'red'     ]

	" VISUAL
	let s:V1 = s:N1
	let s:V2 = [ 'black' , 'yellow'     , 'black' , 'yellow' ]
	let s:V3 = [ 'black' , 'darkyellow' , 'black' , 'yellow' ]

	" INACTIVE
	let s:A1 = [ 'grey' , 'black' , 'grey' , 'black' ]
	let s:A2 = [ 'black' , 'grey' , 'black' , 'grey' ]
	let s:A3 = [ 'black' , 'grey' , 'black' , 'grey' ]

	" CTRLP
	let s:CP1 = [ 'white' , 'green' , 'white' , 'green' ]
	let s:CP2 = [ 'white' , 'green' , 'white' , 'green' ]
	let s:CP3 = [ 'green' , 'black' , 'green' , 'black' ]

endif

let g:airline#themes#cooler#palette.normal   = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#cooler#palette.insert   = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#cooler#palette.replace  = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#cooler#palette.visual   = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#cooler#palette.inactive = airline#themes#generate_color_map(s:A1, s:A2, s:A3)

" CTRLP
if get(g:, 'loaded_ctrlp', 0)
	let g:airline#themes#cooler#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(s:CP1, s:CP2, s:CP3)
endif


