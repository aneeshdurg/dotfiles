" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
" Initialize plugin system
call plug#end()

set hlsearch!
let g:rehash256 = 1
let g:molokai_original = 1

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

colorscheme molokai


