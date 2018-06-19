" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'ntpeters/vim-better-whitespace'
Plug 'cloudhead/neovim-fuzzy' " requires ag > 0.33.0 and fzy
Plug 'FooSoft/vim-argwrap'
Plug 'Numkil/ag.nvim' " requires ag
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'
Plug 'mhinz/vim-startify'
" Initialize plugin system
call plug#end()

" let $NVIM_LISTEN_ADDRESS = system("mktemp --suffix=vimserver")

set nohlsearch
let g:rehash256 = 1
let g:molokai_original = 1

let g:startify_custom_header =
    \ 'map(split(system("date +\"%a, %b %d %Y\" | figlet -f small"), "\n"), "\"   \". v:val")'

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

set makeprg=build

" Set environment variable to let subprocess of nvim know that they are spawned
" from a vim process. se .bashrc for an example of how this can be used to avoid
" opening recursive instances of vim.
let $NVIM_ACTIVE="true"

" autocmd VimLeave * !rm $NVIM_LISTEN_ADDRESS
autocmd FileType startify DisableWhitespace
autocmd FileType * set colorcolumn=81
autocmd FileType javascript set colorcolumn=121
tnoremap <Esc><Esc> <C-\><C-n>

map <C-c><C-c> :set colorcolumn=81<CR>
map <C-c><C-d> :s/  *$//g <CR>
map <C-c><C-n> :set number!<CR>
map <C-w><C-m> :sp<CR> :wincmd T<CR>

nnoremap <C-p> :FuzzyOpen<CR>
nnoremap <silent> <leader>a :ArgWrap<CR>
" inoremap ( ()<ESC>i
" inoremap [ []<ESC>i
" inoremap { {}<ESC>i
" inoremap ' ''<ESC>i
" inoremap " ""<ESC>i
" inoremap ` ``<ESC>i
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'
if filereadable("~/src/tools/editors/vim/plugin/figlet.vim")
    source ~/src/tools/editors/vim/plugin/figlet.vim
endif

set dictionary=/usr/share/dict/words
set wildignorecase
