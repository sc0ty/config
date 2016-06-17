let g:airline#themes#cooler#palette = {}

" NORMAL
let s:N1 = [ '#000000' , '#E4E4E4' , 'black' , 'white' ]
let s:N2 = [ '#E4E4E4' , '#0087AF' , 'black' , 'darkcyan' ]
let s:N3 = [ '#EEEEEE' , '#005F87' , 'white' , 'darkblue' ]
let g:airline#themes#cooler#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

" INSERT & REPLACE
let s:I1 = s:N1
let s:I2 = [ '#E4E4E4' , '#AF2800' , 188 , 124 ]
let s:I3 = [ '#EEEEEE' , '#872800' , 231 , 88  ]
let g:airline#themes#cooler#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#cooler#palette.replace = airline#themes#generate_color_map(s:I1, s:I2, s:I3)

" VISUAL
let s:V1 = s:N1
let s:V2 = [ '#E4E4E4' , '#AF5F00' , 188 , 130 ]
let s:V3 = [ '#EEEEEE' , '#875300' , 231 , 94  ]
let g:airline#themes#cooler#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

" INACTIVE
let s:IA1 = [ '#585858' , '#E4E4E4' , 59  , 188 ]
let s:IA2 = [ '#E4E4E4' , '#466D79' , 188 , 60  ]
let s:IA3 = [ '#EEEEEE' , '#324E59' , 231 , 59  ]
let g:airline#themes#cooler#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)

let g:airline#themes#cooler#palette.accents = {
      \ 'red': [ '#ff0000' , '' , 196 , ''  ]
      \ }

" CTRLP
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let s:CP1 = [ '#E4E4E4' , '#00AFA2' , 188 , 37 ]
let s:CP2 = [ '#EEEEEE' , '#008787' , 231 , 30 ]
let s:CP3 = [ '#585858' , '#E4E4E4' , 59 , 188 ]
let g:airline#themes#cooler#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(s:CP1, s:CP2, s:CP3)

