set nocompatible

" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
  execute '!mkdir -p ~/.vim/autoload'
  execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/bundle')
" utils
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-abolish'
Plug 'jlanzarotta/bufexplorer'
Plug 'mbbill/undotree'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'easymotion/vim-easymotion'
Plug 'will133/vim-dirdiff'
Plug 'mattn/webapi-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ggml-org/llama.vim'

" generic code helpers
Plug 'tpope/vim-endwise'
Plug 'vim-scripts/delimitMate.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'
Plug 'editorconfig/editorconfig-vim'
Plug 'tmhedberg/matchit'
Plug 'dense-analysis/ale'
Plug 'prabirshrestha/vim-lsp'
Plug 'rhysd/vim-lsp-ale'
Plug 'janko/vim-test'
Plug 'puremourning/vimspector'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'gryf/pylint-vim'

" specific code holders/syntax
Plug 'elzr/vim-json'
Plug 'othree/yajs.vim'
Plug 'othree/xml.vim'
Plug 'mxw/vim-jsx'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'vim-ruby/vim-ruby'
Plug 'chr4/nginx.vim'
Plug 'lepture/vim-jinja'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml', { 'branch': 'main' }
Plug 'chrisbra/csv.vim'
Plug 'masukomi/vim-markdown-folding'

" misc
Plug 'vim-scripts/ScrollColors'
Plug 'kshenoy/vim-signature'
Plug 'jasonccox/vim-wayland-clipboard'
Plug 'blindFS/flattr.vim'
call plug#end()
filetype plugin indent on

source ~/.vim/plugin/abolish.vim

" fix char encoding on mac
scriptencoding utf-8
set encoding=utf-8

" allow backspacing over everything
set backspace=indent,eol,start

"set backups to central location
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" lots of defaults
set background=dark
syntax on
set nu
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif
colorscheme flattr
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set history=1000
set colorcolumn=80,100

" llama.vim
"let g:llama_config = {
"      \ 'endpoint_fim': 'http://192.168.1.36:8012/infill',
"      \ 'endpoint_inst':'http://192.168.1.36:8012/v1/chat/completions'
"      \ }

" vim-jsx load .js files too
let g:jsx_ext_required = 0

" supertab scroll setting top to bottom
let g:SuperTabDefaultCompletionType = '<C-n>'

" undotree settings
let g:undotree_WindowLayout = 4
let g:undotree_SplitWidth = 40

" ack settings for silver searcher (ag)
" let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ackprg = 'rg --vimgrep --no-heading'

" custom mappings
"nnoremap <F5> :UndotreeToggle<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <leader>aa :Rg <C-r><C-w><cr>

let NERDTreeIgnore=['\.pyc$', '__pycache__']

" Super tab mappings
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-x><C-o>

" vim-test mappings
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tt :TestFile<CR>
nnoremap <silent> <leader>tT :TestLast<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>
let test#strategy = "vimterminal"
"let test#strategy = "kitty"

" ale bindings
nnoremap <silent> <leader>gd :ALEGoToDefinition<CR>
nnoremap <silent> <leader>ad :ALEDetail<CR>
nnoremap <silent> <leader>af :ALEFix<CR>

" rust/cargo bindings
nnoremap <silent> <leader>rc :!cargo run<CR>
nnoremap <silent> <leader>rp :RustPlay<CR>

" LSP configurations for vim-lsp
if executable('gopls')
    autocmd User lsp_setup call lsp#register_server({
        \   'name': 'gopls',
        \   'cmd': ['gopls'],
        \   'allowlist': ['go', 'gomod'],
        \ })
endif
if executable('rust-analyzer')
    autocmd User lsp_setup call lsp#register_server({
        \   'name': 'analyzer',
        \   'cmd': ['rust-analyzer'],
        \   'allowlist': ['rust'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    " setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" ale Settings
let g:ale_ruby_rubocop_executable = 'bundle'

let g:ale_linters_ignore = {
      \ 'go': ['gopls'],
      \ 'ruby': ['standardrb','ruby','brakeman'],
      \ 'rust': ['rls'],
      \ 'typescriptreact': ['deno'],
      \ 'typescript': ['deno']
      \ }
let g:ale_fixers = {
      \   'ruby': ['standardrb'],
      \   'go': ['gofmt', 'goimports'],
      \   'rust': ['rustfmt'],
      \   'terraform': ['terraform'],
      \   'markdown': ['dprint'],
      \   'python': ['black'],
      \   'html': ['prettier'],
      \   'jinja.html': ['prettier']
      \}
let g:ale_linters = {
      \ 'go': ['golint'],
      \ 'rust': ['cargo', 'analyzer']
      \ }

let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_autoimport = 1
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_rust_cargo_check_all_targets = 1
let g:ale_rust_cargo_check_tests = 1
" let g:ale_rust_analyzer_config = {
"      \ 'cargo': { 'features': 'all' },
"      \ 'check': { 'features': 'all' }
"      \ }
" let g:ale_terraform_terraform_executable = 'tofu'
" let g:ale_terraform_fmt_executable = 'tofu'

" rust.vim things
let g:rust_clip_command = 'xclip -selection clipboard'
let g:rustfmt_autosave = 1

" maps and bindings etc
function! OpenZippedFile(f)
  " get number of new (empty) buffer
  let l:b = bufnr('%')
  " construct full path
  let l:f = substitute(a:f, '$$virtual.*cache', 'cache', '')
  let l:f = 'zipfile:' . getcwd() . '/' . substitute(l:f, '.zip/', '.zip::', '')
  " swap back to original buffer
  b #
  " delete new one
  exe 'bd! ' . l:b
  " open buffer with correct path
  sil exe 'e ' . l:f
  " read in zip data
  call zip#Read(l:f, 1)
endfunction

augroup yarngtd
  au!

  au BufReadCmd *.yarn/$$virtual/*.zip/* call OpenZippedFile(expand('<afile>'))
  au BufReadCmd *.yarn/cache/*.zip/* call OpenZippedFile(expand('<afile>'))
augroup END

hi SpellBad ctermbg=8

let g:vimspector_enable_mappings = 'HUMAN'
nmap <Leader>dl :call vimspector#Launch("Run Test")<CR>
xmap <Leader>di <Plug>VimspectorBalloonEval
nmap <LocalLeader><F11> <Plug>VimspectorUpFrame
nmap <LocalLeader><F12> <Plug>VimspectorDownFrame

nnoremap <silent> <leader>sb :Git blame<CR>
nnoremap <silent> <leader>sd :Gvdiffsplit<CR>
nnoremap <silent> <leader>ss :G<CR>

function! RustCoverage()
  " harvested from https://blog.rng0.io/how-to-do-code-coverage-in-rust
  let rm = execute('!rm -rf coverage')
  let mkdir = execute('!mkdir -p coverage')

  :silent execute '!CARGO_INCREMENTAL=0 RUSTFLAGS=-Cinstrument-coverage LLVM_PROFILE_FILE=cargo-test-%p-%m.profraw cargo test'

  let val = execute('!grcov . --binary-path ./target/debug/deps/ -s . -t lcov --branch --ignore-not-existing --ignore "../*" --ignore "/*" -o coverage/coverage.info')

  :silent execute '!rm -rf cargo-test-src/'

  redraw!
endfunction

nnoremap <silent> <leader>rt :call RustCoverage()<CR>
