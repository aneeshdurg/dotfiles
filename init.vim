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
Plug 'altercation/vim-colors-solarized'
Plug 'cloudhead/neovim-fuzzy' " requires ag > 0.33.0 and fzy
Plug 'FooSoft/vim-argwrap'
Plug 'lambdalisue/suda.vim'
Plug 'lepture/vim-jinja'
Plug 'mhinz/vim-startify'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Numkil/ag.nvim' " requires ag
Plug 'radenling/vim-dispatch-neovim'
Plug 'tomasr/molokai'
Plug 'tpope/vim-dispatch'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'tpope/vim-sleuth'
" Initialize plugin system
call plug#end()

"""
"| |    __ _ _ __   __ _  __ _ _   _  __ _  __ _  ___
"| |   / _` | '_ \ / _` |/ _` | | | |/ _` |/ _` |/ _ \
"| |__| (_| | | | | (_| | (_| | |_| | (_| | (_| |  __/
"|_____\__,_|_| |_|\__,_|\__, |\__,_|\__,_|\__, |\___|
"                        |___/             |___/
" ____                              ____             __ _
"/ ___|  ___ _ ____   _____ _ __   / ___|___  _ __  / _(_) __ _
"\___ \ / _ \ '__\ \ / / _ \ '__| | |   / _ \| '_ \| |_| |/ _` |
" ___) |  __/ |   \ V /  __/ |    | |__| (_) | | | |  _| | (_| |
"|____/ \___|_|    \_/ \___|_|     \____\___/|_| |_|_| |_|\__, |
"                                                         |___/
" FIGLET: language server config
"""
" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

let g:deoplete#enable_at_startup = 1
let g:deoplete#num_processes = 1
let g:deoplete#auto_complete_start_length = 1
"""

let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai
hi Normal guibg=None ctermbg=None
hi LineNr guibg=NONE ctermbg=NONE guifg=white ctermfg=white
hi Visual term=reverse cterm=reverse guibg=White
hi ColorColumn ctermbg=Grey

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
set autochdir

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
let $NVIM_LISTEN_ADDRESS=v:servername

autocmd BufNewFile,BufRead *.qs set syntax=cs
autocmd BufNewFile,BufRead bash-fc.* set filetype=bashfc
autocmd TermOpen * set filetype=terminal

" Prevents start page from highlighting spaces in ascii art
autocmd FileType startify DisableWhitespace
" Disables line nos only in terminal mode
autocmd FileType * set number
autocmd Filetype terminal set nonumber
" Different length limit for js
autocmd FileType * set colorcolumn=81
autocmd FileType javascript set colorcolumn=121

autocmd FileType tex set textwidth=0

autocmd FileType gitcommit nnoremap <buffer> :q<CR> :bd<CR>
autocmd FileType gitcommit nnoremap <buffer> :wq<CR> :w\|bd<CR>
autocmd FileType gitcommit nnoremap <buffer> q<CR> :bd<CR>
autocmd FileType gitcommit nnoremap <buffer> wq<CR> :w\|bd<CR>

autocmd FileType bashfc nnoremap <buffer> :q<CR> :bd<CR>
autocmd FileType bashfc nnoremap <buffer> :wq<CR> :w\|bd<CR>
autocmd FileType bashfc nnoremap <buffer> q<CR> :bd<CR>
autocmd FileType bashfc nnoremap <buffer> wq<CR> :w\|bd<CR>

" Double escape to return to normal mode in terminal
tnoremap <Esc><Esc> <C-\><C-n>

" Saves buffer to variable which can be used to move buffers around easily.
" <C-c><C-c> will save the buffer
" <C-c><C-x> will save the buffer and then close the split
" <C-c><C-p> will resotre a saved buffer
map <C-c><C-c> :let g:saved_bufnum=bufnr('%')<CR>
map <C-c><C-x> :let g:saved_bufnum=bufnr('%') \| q <CR>
map <C-c><C-p> :exe "b"g:saved_bufnum<CR>

" Disabling for now
"nnoremap :q<CR> :clo<CR>
"nnoremap :wq<CR> :w\|clo<CR>

nnoremap <silent> <esc> :noh<cr><esc>

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
    undo
    write
    redo
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


map <C-w><C-m> :tab split<CR>
map <C-w><C-e> yy:new<CR>P:set filetype=scratchbuf<CR>
autocmd FileType scratchbuf nnoremap <buffer>:q :%y<CR>:q!<CR>

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
