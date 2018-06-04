" ~/.config/nvim/init.vim

call plug#begin('~/.local/share/nvim/plugged')
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'fatih/molokai'
Plug 'fatih/vim-go' " , { 'do': ':GoInstallBinaries' }
Plug 'scrooloose/nerdtree'
Plug 'justinmk/vim-sneak'
" Autocomplete
" First run:
"  pip2 install --upgrade neovim
"  pip3 install --upgrade neovim
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.local/share/nvim/plugged/gocode/vim/symlink.sh' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make'}
" Snippet completion
Plug 'Shougo/neocomplcache'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
call plug#end()

" Workaround for weird character bug
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
set guicursor=

set number

if has('nvim')
    " Enable deoplete on startup
    let g:deoplete#enable_at_startup = 1
endif
           

" Disable deoplete when in multi cursor mode
function! Multiple_cursors_before()
    let b:deoplete_disable_auto_complete = 1
endfunction
function! Multiple_cursors_after()
    let b:deoplete_disable_auto_complete = 0
endfunction

" Ctrl-p
set wildignore+=*/vendor/*
set wildignore+=*/go/src/github.com/*
set wildignore+=*/go/src/gopkg.in/*
set wildignore+=*/go/bin/*
set wildignore+=*/go/pkg/*

" Nerd Tree (ctrl-e)
map <C-e> :NERDTreeToggle<CR>
" Close on file open
let g:NERDTreeQuitOnOpen = 1

" Easymotion (space-b, space-w, space-f, space-F)
map <SPACE> <Plug>(easymotion-prefix)

" Molokai color scheme
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

" Map the leader to a comma
"  nnoremap <SPACE> <Nop>
"  let mapleader = "\<Space>"
let mapleader = ","

" Write file on build
set autowrite

" Go to next error
map <C-n> :cnext<CR>
" Go to prev error
map <C-m> :cprevious<CR>
" Close quickfix window (error box)
nnoremap <leader>a :cclose<CR>

" SNIPPETS
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" GO SETTINGS
" gd - GoDef
" ctrl-t - GoDefPop (where gd was called)
" ctrl-n - Next error (:cnext)
" ctrl-m - Prev error (:cprevious)
" K - GoDoc

" Only use quickfix window (not location lists)
let g:go_list_type = "quickfix"
" Auto import
let g:go_fmt_command = "goimports"
" Show matching identifiers on hover
"  let g:go_auto_sameids = 1
" Show type info on hover
"  let g:go_auto_type_info = 1
" Show type info after 100ms instead of default 800ms
set updatetime=100
" Pretty colors
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
" Tab size
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
" Linting
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_deadline = "5s"
" Only call fast linters on save
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
" Call linting on save
let g:go_metalinter_autosave = 1
" Use neosnippet
let g:go_snippet_engine = "neosnippet"

" QUICK GO COMMANDS
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>e  <Plug>(go-rename)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <Leader>i  <Plug>(go-implements)
autocmd FileType go nmap <leader>f  <Plug>(go-referrers)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

autocmd Filetype yaml setlocal ts=2 sts=2 sw=2
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal expandtab ts=2 sts=2 sw=2

" Use the system clipboard
set clipboard+=unnamedplus
