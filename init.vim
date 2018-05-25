" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FooSoft/vim-argwrap'
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

autocmd FileType * set colorcolumn=81
autocmd FileType javascript set colorcolumn=121
tnoremap <Esc> <C-\><C-n>

map <C-c><C-c> :set colorcolumn=81<CR>
map <C-c><C-d> :s/  *$//g <CR>
map <C-c><C-n> :set number!<CR>

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
