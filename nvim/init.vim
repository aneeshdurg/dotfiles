" require 'config' before anything else because it loads all plugins
lua require('config')

" JS template highlight all as html
let g:htl_all_templates = "true"

" Required for operations modifying multiple buffers like rename.
set hidden

nnoremap <silent> <M-A> :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> KK :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> K :Telescope lsp_definitions<CR>
nnoremap <silent> <F2> :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> R :Telescope lsp_references<CR>
vnoremap <silent> gf :lua vim.lsp.buf.range_formatting()<CR>
nnoremap <silent> gf :lua vim.lsp.buf.format()<CR>
nnoremap <silent> <leader>n :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>p :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <F1> 
inoremap <silent> <F1> 

vnoremap <C-p> x:put =system(['python3', '-c', @@])<CR>

runtime lua/helpers.lua

let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai
hi Normal guibg=None ctermbg=None
hi LineNr guibg=NONE ctermbg=NONE guifg=white ctermfg=white
hi Visual term=reverse cterm=reverse guibg=#4422af
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

" setlocal cindent
" setlocal cinoptions=:0,l1,t0,(4,u0,Ws
" setlocal formatoptions=croql
" setlocal comments=sr:/*,mb:*,el:*/,://

set termguicolors

" Scroll up/down
map <C-j> <C-e>
map <C-k> <C-y>

" Open a terminal in a split
nnoremap <C-t><C-t> :vs<CR>:term<CR> i
nnoremap <C-t><C-p> :vs<CR>:term python<CR> i
nnoremap <C-t><C-c> :tabnew<CR>:term browsh --startup-url https://en.cppreference.com<CR>i
nnoremap <C-t> :vs<CR>:term<CR> i

" Open a terminal in the repo root
nnoremap <C-b> :vs<CR>:Gcd<CR>:term<CR> i

" Set environment variable to let subprocess of nvim know that they are spawned
" from a vim process. see .bashrc for an example of how this can be used to
" avoid opening recursive instances of vim.
let $NVIM_ACTIVE="true"
let $NVIM_LISTEN_ADDRESS=v:servername

autocmd BufNewFile,BufRead *.qs set syntax=cs
autocmd BufNewFile,BufRead *.fish set syntax=sh

autocmd BufNewFile,BufRead bash-fc* set filetype=bashfc
autocmd BufNewFile,BufRead *tmp.*.fish set filetype=bashfc
autocmd BufNewFile,BufRead tmp.*.fish set filetype=bashfc

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

autocmd FileType hgcommit nnoremap <buffer> :q<CR> :bd<CR>
autocmd FileType hgcommit nnoremap <buffer> :wq<CR> :w\|bd<CR>
autocmd FileType hgcommit nnoremap <buffer> q<CR> :bd<CR>
autocmd FileType hgcommit nnoremap <buffer> wq<CR> :w\|bd<CR>

autocmd FileType gitcommit nnoremap <buffer> :q<CR> :bd<CR>
autocmd FileType gitcommit nnoremap <buffer> :wq<CR> :w\|bd<CR>
autocmd FileType gitcommit nnoremap <buffer> q<CR> :bd<CR>
autocmd FileType gitcommit nnoremap <buffer> wq<CR> :w\|bd<CR>

autocmd FileType bashfc nnoremap <buffer> :q<CR> :bd<CR>
autocmd FileType bashfc nnoremap <buffer> :wq<CR> :w\|bd<CR>
autocmd FileType bashfc nnoremap <buffer> q<CR> :bd<CR>
autocmd FileType bashfc nnoremap <buffer> wq<CR> :w\|bd<CR>

autocmd FileType markdown setlocal spell spelllang=en_us

" Double escape to return to normal mode in terminal
tnoremap <Esc><Esc> <C-\><C-n>

" Saves buffer to variable which can be used to move buffers around easily.
" <C-c><C-c> will save the buffer
" <C-c><C-x> will save the buffer and then close the split
" <C-c><C-p> will resotre a saved buffer
map <C-c><C-c> :let g:saved_bufnum=bufnr('%')<CR>
map <C-c><C-x> :let g:saved_bufnum=bufnr('%') \| q <CR>
map <C-c><C-p> :exe "b"g:saved_bufnum<CR>

nnoremap <silent> <esc> :noh<cr><esc>

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

let g:fuzzy_rootcmds = [
\ ["git", "rev-parse", "--show-toplevel"],
\ ]



let is_delphinus = split(hostname(), '\.')[0] == 'delphinus'

" Ignore .txt files in git_files if on delphinus (work)
if is_delphinus
  inoremap <C-p><C-p> <Esc>:lua require('telescope.builtin').git_files({git_command={"git", "ls-files", ".", ":!:*.txt"}})<CR>
  nnoremap <C-p><C-p> :lua require('telescope.builtin').git_files({git_command={"git", "ls-files", ".", ":!:*.txt"}})<CR>
else
  inoremap <C-p><C-p> <Esc>:Telescope git_files<CR>
  nnoremap <C-p><C-p> :Telescope git_files<CR>
endif

nnoremap <C-p><C-l> :Telescope find_files<CR>
nnoremap <C-p><C-s> :Telescope lsp_dynamic_workspace_symbols<CR>
inoremap <C-p><C-s> <Esc>:Telescope lsp_dynamic_workspace_symbols<CR>
nnoremap <C-p><C-g> :Gcd<CR>:Telescope live_grep<CR>
inoremap <C-p><C-g> <Esc>:Gcd<CR>:Telescope live_grep<CR>
nnoremap <C-p><C-e> :Gcd<CR>:cfile error.errs<CR>:Telescope quickfix<CR>
nnoremap <silent> <leader>a :ArgWrap<CR>

" git commands
nnoremap <C-g><C-b> :Telescope git_branches<CR>
nnoremap <C-g><C-i> :Telescope git_branches<CR>
nnoremap <C-g><C-s> :Telescope git_status<CR>
nnoremap <C-g><C-h> :Telescope git_stash<CR>
nnoremap <C-g><C-l> :Telescope git_commits<CR>
nnoremap <C-g><C-a> :Git <CR>
nnoremap <C-g><C-c> :Git commit <CR>
nnoremap <C-g><C-p> :vs \| term gp <CR>
nnoremap <C-g><C-p><C-f> :vs \| term gp -f <CR>

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
