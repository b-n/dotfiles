set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'vim-scripts/delimitMate.vim'
Plugin 'vim-scripts/Gundo'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/ScrollColors'
Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'
Plugin 'neowit/vim-force.com'
Plugin 'elzr/vim-json'
Plugin 'Valloric/YouCompleteMe'
Plugin 'flazz/vim-colorschemes'
Plugin 'bling/vim-airline'

call vundle#end()
filetype plugin on

set background=dark
syntax on
set nu
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif
colorscheme candycode
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set history=1000

let g:apex_backup_folder="~/.vim/backup"
let g:apex_temp_folder="~/.vim/temp"
let g:apex_properties_folder="~/.vim/properties"
let g:apex_tooling_force_dot_com_path="~/.vim/tooling-force.com.jar"
let g:apex_workspace_path="~/Workspace/sfdc"
let g:apex_maxPollRequests="10000"
let g:apex_pollWaitMillis="1000" 
let g:apex_server=1
let g:apex_server_timeoutSec=60*60*2
let g:apex_quickfix_coverage_toggle_shortcut = "c"

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetsDir="~/.vim/snips"

" gundo settings
let g:gundo_right = 1
let g:gundo_width = 40

" custom mappings
nnoremap <F5> :GundoToggle<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <silent> <C-n> :NERDTreeToggle %<CR>
nnoremap <silent> <C-d> :w<CR>:ApexDeploy<CR>
nnoremap <leader>ac :ApexTestCoverageToggle<CR>
nnoremap <leader>al :ApexLog<CR>
nnoremap <leader>ae :ApexExecuteAnonymous<CR>
nnoremap <leader>as :ApexScratch<CR>
nnoremap <leader>ar :ApexRefreshProject<CR>
nnoremap <leader>ab :ApexStageAdd<CR>
nnoremap <leader>av :ApexStageClear<CR> 

"reformat single line braces to a better syntax
nnoremap <C-b> :%s/\n[\t\ ]*{/\ {/g<CR>:%s/}[\n\t\ ]*else/}\ else/g<CR>
"fix poor object creation string
nnoremap <C-I> :s/\v([ ]*)[^\.]*\.(.*);/    \1\2,/g<CR>

inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-x><C-o>

function! s:setApexShortcuts()

  """"""""""""""""""""""""""""""""""""""""""
  " Search in files
  """"""""""""""""""""""""""""""""""""""""""

  " search exact word
  nmap <leader>sc :noautocmd vimgrep /\<<C-R><C-W>\>/j ../**/*.cls ../**/*.trigger <CR>:cwin<CR>
  nmap <leader>st :noautocmd vimgrep /\<<C-R><C-W>\>/j ../**/*.trigger <CR>:cwin<CR>
  nmap <leader>sp :noautocmd vimgrep /\<<C-R><C-W>\>/j ../**/*.page <CR>:cwin<CR>
  nmap <leader>sa :noautocmd vimgrep /\<<C-R><C-W>\>/j ../**/*.cls ../**/*.trigger ../**/*.page <CR>:cwin<CR>

  " search - *contains* - partal match is allowed
  nmap <leader>sC :noautocmd vimgrep /<C-R><C-W>/j ../**/*.cls ../**/*.trigger <CR>:cwin<CR>
  nmap <leader>sT :noautocmd vimgrep /<C-R><C-W>/j ../**/*.trigger <CR>:cwin<CR>
  nmap <leader>sP :noautocmd vimgrep /<C-R><C-W>/j ../**/*.page <CR>:cwin<CR>
  nmap <leader>sA :noautocmd vimgrep /<C-R><C-W>/j ../**/*.cls ../**/*.trigger ../**/*.page <CR>:cwin<CR>

  " prepare search string, but do not run
  nmap <leader>sm :noautocmd vimgrep /\c\<<C-R><C-W>\>/j ../**/*.cls ../**/*.trigger ../**/*.page \|cwin

  " search visual selection in Apex project
  function! ApexFindVisualSelection(searchType) range
    let l:apex_search_patterns = {'class': '../**/*.cls ../**/*.trigger', 
							     \'trigger': '../**/*.trigger', 
							     \'page': '../**/*.page', 
							     \'all': '../**/*.cls ../**/*.trigger ../**/*.page'}
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let commandLine="noautocmd vimgrep " . '/'. l:pattern . '/j '

    let commandLine = commandLine . l:apex_search_patterns[a:searchType]
    "echo "commandLine=" . commandLine
    execute commandLine 
    execute 'cwin'

    let @/ = l:pattern
    let @" = l:saved_reg
  endfunction
  vmap <leader>sc :call ApexFindVisualSelection('class')<CR>
  vmap <leader>st :call ApexFindVisualSelection('trigger')<CR>
  vmap <leader>sp :call ApexFindVisualSelection('page')<CR>
  vmap <leader>sa :call ApexFindVisualSelection('all')<CR>

endfunction

" load shortcut mapping when one of apexcode file types is detected/loaded
autocmd FileType apexcode.java call s:setApexShortcuts()
autocmd FileType apexcode.html call s:setApexShortcuts()
autocmd FileType apexcode.javascript call s:setApexShortcuts()
autocmd FileType apexcode call s:setApexShortcuts()
