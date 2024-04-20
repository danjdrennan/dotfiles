syntax enable
set number
set relativenumber

set tabstop=4
set shiftwidth=4
set expandtab

set colorcolumn=80
highlight ColorColumn ctermbg=gray guibg=gray

set textwidth=80

set smartindent
set autoindent

inoremap <C-D> <ESC>ddi

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
