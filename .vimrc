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
Plug 'vim-scripts/ZoomWin'
Plug 'easymotion/vim-easymotion'
Plug 'will133/vim-dirdiff'
Plug 'mileszs/ack.vim'
Plug 'mattn/webapi-vim'

" generic code helpers
Plug 'tpope/vim-endwise'
Plug 'vim-scripts/delimitMate.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'
Plug 'editorconfig/editorconfig-vim'
Plug 'tmhedberg/matchit'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'janko/vim-test'
Plug 'puremourning/vimspector'
Plug 'github/copilot.vim'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'gryf/pylint-vim'

" specific code holders/syntax
Plug 'tpope/vim-rails'
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
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'hashivim/vim-terraform'
Plug 'cespare/vim-toml', { 'branch': 'main' }
Plug 'earthly/earthly.vim', { 'branch': 'main' }

" misc
Plug 'vim-scripts/ScrollColors'
Plug 'kshenoy/vim-signature'
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
nnoremap <silent> <C-n> :NERDTreeToggle %<CR>
nnoremap <silent> <leader>aa :Ack <C-r><C-w><cr>

" Super tab mappings
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-x><C-o>

"git rebase changes
"nnoremap <silent> <leader>gd :s/^\S*\ /drop\ /g<CR>
nnoremap <silent> <leader>gp :s/^\S*\ /pick\ /g<CR>
nnoremap <silent> <leader>gs :s/^\S*\ /squash\ /g<CR>
nnoremap <silent> <leader>ge :s/^\S*\ /edit\ /g<CR>

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
      \   'rust': ['rustfmt'],
      \   'terraform': ['terraform'],
      \   'markdown': ['dprint'],
      \   'python': ['black']
      \}
let g:ale_linters = {
      \ 'rust': ['cargo', 'analyzer']
      \ }

let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_autoimport = 1
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_rust_cargo_check_all_targets = 1
let g:ale_rust_cargo_check_tests = 1

" rust.vim things
let g:rust_clip_command = 'xclip -selection clipboard'
let g:rustfmt_autosave = 1

" terraform vim things
let g:terraform_fmt_on_save = 1

let g:terraform_fmt_on_save = 1

" Execute and get results in new window
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^ShellExecPop$')
  silent! execute  winnr < 0 ? 'botright new ShellExecPop' : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize 8'
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  silent! execute 'wincmd p'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

au BufRead,BufNewFile */cw-nginx/*/*.conf set ft=nginx
au BufRead,BufNewFile */cw-nginx/*/*.proxy set ft=nginx

nnoremap <silent> <leader>rs :0s/^/\#\ frozen_string_literal:\ true\r\r/g<CR>:w<CR>

command! -bang -bar -nargs=* Gpush execute 'Dispatch<bang> -dir=' . fnameescape(FugitiveGitDir()) 'git push' <q-args>

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

imap <M-Up> <Plug>(copilot-previous)
imap <M-Down> <Plug>(copilot-next)

hi SpellBad ctermbg=8

let g:vimspector_enable_mappings = 'HUMAN'
nmap <Leader>dl :call vimspector#Launch("Run Test")<CR>
xmap <Leader>di <Plug>VimspectorBalloonEval
nmap <LocalLeader><F11> <Plug>VimspectorUpFrame
nmap <LocalLeader><F12> <Plug>VimspectorDownFrame

nnoremap <leader>rs :s/'\([^']\+\)'/:\1/g<CR>

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

" Ensure Tiltfile is highlighted as Bazel code
au BufRead,BufNewFile Tiltfile set filetype=python
