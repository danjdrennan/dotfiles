syntax enable
set number
set relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set colorcolumn=80
set textwidth=80
highlight ColorColumn ctermbg=gray guibg=gray

set smartindent
set autoindent

set nocompatible
set encoding=utf-8
set wildmenu
set showcmd

set incsearch
set hlsearch
set smartcase

filetype on
filetype plugin on
filetype indent on

" completely necessary to any configuration
let mapleader=" "

" Remove trailing whitespace on write
autocmd BufWritePre * :%s/\\s\\+$//e

" These tend to be better for text editing than the global settings, which are
" better for programming langs
autocmd FileType md setlocal spell spelllang=en_us
autocmd FileType md setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType tex setlocal spell spelllang=en_us
autocmd FileType tex setlocal tabstop=2 shiftwidth=2 softtabstop=2

augroup auto_comment
    au!
    au FileType c,cpp,java,scala let b:comment_leader = '// '
    au FileType sh,python let b:comment_leader = '# '
    au FileType vim let b:comment_leader = '" '
    au FileType tex let b:comment_leader = '% '
augroup END

function! CommentToggle()
    if getline('.') =~ '^\s*' . b:comment_leader
        execute 'silent! s/^\s*' . b:comment_leader . '\s*//'
    else
        execute 'silent! s/^\s*/' . b:comment_leader . '/e'
    endif
endfunction

nnoremap gcc :call CommentToggle()<CR>
nnoremap <leader>pv :Ex<CR>
