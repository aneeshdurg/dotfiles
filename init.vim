"       _             _
" _ __ | |_   _  __ _(_)_ __  ___
"| '_ \| | | | |/ _` | | '_ \/ __|
"| |_) | | |_| | (_| | | | | \__ \
"| .__/|_|\__,_|\__, |_|_| |_|___/
"|_|            |___/
" FIGLET: plugins
"
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


let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

let g:ag_working_path_mode="r"
let g:agprg="rg --vimgrep --smart-case --with-filename --no-heading"
let g:startify_custom_header =
    \ 'map(split(system("date +\"%a, %b %d %Y\" | figlet -f small"), "\n"), "\"   \". v:val")'

" ___  ___| |_| |_(_)_ __   __ _ ___
"/ __|/ _ \ __| __| | '_ \ / _` / __|
"\__ \  __/ |_| |_| | | | | (_| \__ \
"|___/\___|\__|\__|_|_| |_|\__, |___/
"                          |___/
" FIGLET: settings
"
set colorcolumn=81
set dictionary=/usr/share/dict/words
set makeprg=build
set mouse=a
set nohlsearch
set number
set textwidth=80
set wildignorecase

" ___ _ __   __ _  ___(_)_ __   __ _
"/ __| '_ \ / _` |/ __| | '_ \ / _` |
"\__ \ |_) | (_| | (__| | | | | (_| |
"|___/ .__/ \__,_|\___|_|_| |_|\__, |
"    |_|                       |___/
" FIGLET: spacing
"
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Scroll up/down
map <C-j> <C-e>
map <C-k> <C-y>

" Set environment variable to let subprocess of nvim know that they are spawned
" from a vim process. see .bashrc for an example of how this can be used to
" avoid opening recursive instances of vim.
let $NVIM_ACTIVE="true"

autocmd BufNewFile,BufRead *.qs set syntax=cs

" Prevents start page from highlighting spaces in ascii art
autocmd FileType startify DisableWhitespace
" Disables line nos only in terminal mode
" Also provides a filetype for terminal
autocmd FileType * set number
autocmd TermOpen * set filetype=terminal
autocmd Filetype terminal set nonumber
" Different length limit for js
autocmd FileType * set colorcolumn=81
autocmd FileType javascript set colorcolumn=121

autocmd FileType gitcommit nnoremap q :bd<CR>
autocmd FileType gitcommit nnoremap wq :w\|bd<CR>

" Double escape to return to normal mode in terminal
tnoremap <Esc><Esc> <C-\><C-n>

" Saves buffer to variable which can be used to move buffers around easily.
" <C-c><C-c> will save the buffer
" <C-c><C-x> will save the buffer and then close the split
" <C-c><C-p> will resotre a saved buffer
map <C-c><C-c> :let g:saved_bufnum=bufnr('%')<CR>
map <C-c><C-x> :let g:saved_bufnum=bufnr('%') \| q <CR>
map <C-c><C-p> :exe "b"g:saved_bufnum<CR>

function! ClangFormatDiff()
  let diff_result = system("diff <(clang-format ".bufname("%").") ".bufname("%"))
  if diff_result == ""
    echo "Formatting looks good!"
    return
  endif

  echo diff_result
  let do_diff = confirm('Perform diff?', "&Yes\n&No", 2)
  if do_diff == 1
    call system("clang-format -i ".bufname("%"))
    edit
    redraw
  endif
endfunc
map <C-c><C-f> :call ClangFormatDiff()<CR>

" Toggles mouse enabled by pressing <C-c><C-m>
function! ToggleMouse()
    if &mouse == 'a'
        set mouse=""
    else
        set mouse=a
    endif
endfunc
map <C-c><C-m> :call ToggleMouse()<CR>


map <C-w><C-m> :sp<CR> :wincmd T<CR>
map <C-w><C-e> yy:new<CR>P:set filetype=scratchbuf<CR>
autocmd FileType scratchbuf nnoremap <buffer> Q :%y<CR>:q!<CR>

nnoremap <C-p> :FuzzyOpen<CR>
nnoremap <silent> <leader>a :ArgWrap<CR>

" Autocomplete parens. Disabled because I don't like how it can't detect when
" there's already a closing paren.
" inoremap ( ()<ESC>i
" inoremap [ []<ESC>i
" inoremap { {}<ESC>i
" inoremap ' ''<ESC>i
" inoremap " ""<ESC>i
" inoremap ` ``<ESC>i

if filereadable("/home/adurg/src/tools/editors/vim/plugin/figlet.vim")
    source /home/adurg/src/tools/editors/vim/plugin/figlet.vim
endif

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
