" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'ntpeters/vim-better-whitespace'
" Initialize plugin system
call plug#end()

set hlsearch!
let g:rehash256 = 1
let g:molokai_original = 1

set expandtab
set tabstop=2
"set shiftwidth=2
set shiftwidth=4
set softtabstop=2

set colorcolumn=81
set textwidth=80
set number

colorscheme molokai

map <C-j> <C-e>
map <C-k> <C-y>

set mouse=a

tnoremap <Esc> <C-\><C-n>

map <C-c><C-c> :set colorcolumn=81<CR>
map <C-c><C-d> :set colorcolumn=0 <CR>
map <C-c><C-n> :set number!<CR>

set dictionary+=/usr/share/dict/words
