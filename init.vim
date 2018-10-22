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
Plug 'lambdalisue/suda.vim'
" Initialize plugin system
call plug#end()

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

autocmd BufNewFile,BufRead *.qs set syntax=cs
autocmd FileType startify DisableWhitespace
autocmd TermOpen * set nonumber
autocmd FileType * set colorcolumn=81
autocmd FileType javascript set colorcolumn=121
autocmd FileType gitcommit nnoremap q :bd<CR>
autocmd FileType gitcommit nnoremap wq :w\|bd<CR>
tnoremap <Esc><Esc> <C-\><C-n>

" Saves buffer to variable which can be used to move buffers around easily.
" <C-c><C-c> will save the buffer
" <C-c><C-x> will save the buffer and then close the split
" <C-c><C-p> will resotre a saved buffer
map <C-c><C-c> :let g:saved_bufnum=bufnr('%')<CR>
map <C-c><C-x> :let g:saved_bufnum=bufnr('%') \| q <CR>
map <C-c><C-p> :exe "b"g:saved_bufnum<CR>

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

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
