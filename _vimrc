" --- WISH LIST ---
"  - Jump to definition
"----------------------------------------------------------------------------------------------------

"set nocompatible              "be iMproved, required
"filetype off                  "required <<========== We can turn it on later

" --- path includes (must be before plugin install) ---
set directory=$HOME/vimfiles/swapfiles/
set rtp+=$HOME/vimfiles/bundle/Vundle.vim
set rtp+=$HOME/vimfiles/colors

" --- plugin install ---
call vundle#begin()
let g:vundle#bundle_dir='$HOME/vimfiles/bundle/'
Plugin 'VundleVim/Vundle.vim'     " vim plugin plugin
Plugin 'ctrlpvim/ctrlp.vim'       " file finder
Plugin 'scrooloose/nerdtree'      " file viewer with tab
Plugin 'skywind3000/asyncrun.vim' " run terminal commands from vim
Plugin 'haya14busa/incsearch.vim' " makes / ? g/ searching better by highlighting all results
Plugin 'webastien/vim-ctags'      " jump to definition (not working)
Plugin 'junegunn/fzf'             " just used for ripgrep. Idk if I want this, seems annoying
Plugin 'junegunn/fzf.vim'         " just used for ripgrep. Idk if I want this, seems annoying
call vundle#end()            " required
filetype plugin indent on    " required

" --- GVIM SETTINGS ---
set guioptions-=M  "remove menu bar
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right scroll bar
set guioptions-=R  "remove right scroll bar
set guioptions-=l  "remove left scroll bar
set guioptions-=L  "remove left scroll bar
set guioptions-=b  "remove bottom scroll bar
set guioptions-=e  "tab bar fix
set guioptions+=a  "gvim copy to system clipboard, on select
set guioptions+=d  "try and use dark theme

" --- TEXT SETTINGS ---
set belloff=all
set ai     " automatic indent
set si     " smart indent
set is     " smart indent
set ts=4   " tab space
set ss=4
set sw=4
set siso=4
set expandtab
set softtabstop=4 " Make the spaces feel like real tabs
set backspace=indent,eol,start
set nocompatible
set autoread " auto read changes to files

" --- GENERAL SETTINGS
set guifont=consolas:h11
"set guifont=fixedsys
colorscheme custom
set splitright
set splitbelow
set ruler
set nopaste
set nonumber     "enables line numbers
set mouse=a    "enable mouse functionality
set nohlsearch "disable highlighting after search complete
set wrap linebreak nolist
set guicursor+=a:blinkon0 "disable blinking cursor
set foldcolumn=0  "remove all empty spaces on the left
syntax on      "sytax highlighting on 

" --- unkown ---
"set textwidth=0
"set wrapmargin=0
"set guioptions-=t
"set ghr=0
"set term=xterm
"set guiheadroom=0
"set guioptions-=e

" look at this
" allowes for multiple tabs to open in a folder or w.e
"set tabpagemax=30
"set laststatus=2
"packloadall
"silent! helptags ALL
"autocmd GUIEnter * silent! WCenter
"autocmd GUIEnter * silent! WToggleClean
" fix copy/paste
"vmap <F4> "+y<ESC><ESC>"+pa
"imap <C-v> <ESC>"+pa
" --- autosave config ---
"let auto_save = 0
"let auto_save_silent = 0
"inoremap <silent> <C-c> <ESC>

" --- Remove trailing whitespace for these file types
autocmd FileType c,cpp,python autocmd BufWritePre <buffer> %s/\s\+$//e

" --- NERDTREE SETTINGS ---
:nnoremap <tab> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeRespectWildIgnore=1
let NERDTreeQuitOnOpen=0
let NERDTreeMinimalUI=1
let NERDTreeMinimalMenu=1
let NERDTreeHighlightCursorline=1
let NERDTreeAutoCenter=1

" --- INCSEARCH SETTINGS ---
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" --- COMMANDS ---
:command Hex %!xxd
:command Hexb %!xxd -r

" --- MAPPINGS ---
nnoremap j gj
nnoremap k gk

" --- ASYNC SETTINGS ---
let g:asyncrun_open = 0
let g:asyncrun_stdin = 1
let g:asyncrun_save = 1
let g:asyncrun_auto = "make"
let g:asyncrun_status = ""

" --- FZF RG SETTINGS ---

" --- QUICKFIX SETTINGS ---
set switchbuf=usetab,newtab " quick fix jump to existing tab or open new tab for file
set errorformat=\ %#%f(%l\\\,%c):\ %m " quick fix error format for clang/msvc (hopefully)
set makeprg=..\misc\build.bat " set default make for quickfix to be my build.bat
function! NextQuickFixError() abort
    let error_count = len(filter(getqflist(), { k,v -> match(v.text, "error") != -1 }))
    let warning_count = len(filter(getqflist(), { k,v -> match(v.text, "warning") != -1 }))
    if error_count != 0 || warning_count != 0
        set laststatus=0
        copen
        try
            :cnext
        catch
            :cfirst
            :cnext
        endtry
    else
        :ccl
    endif
endfunction

function! PrevQuickFixError() abort
    let error_count = len(filter(getqflist(), { k,v -> match(v.text, "error") != -1 }))
    let warning_count = len(filter(getqflist(), { k,v -> match(v.text, "warning") != -1 }))
    if error_count != 0 || warning_count != 0
        set laststatus=0
        copen
        try
            :cprev
        catch
            :clast
            :cprev
        endtry
    else
        :ccl
    endif
endfunction

" --- OPEN/JUMPTO FILE ----
function OpenFile(filename) 
    try
        execute 'tab sbuffer ' . a:filename
        ":tab sbuffer ~/_vimrc
    catch /E94:/
        execute 'tabe ' . a:filename
        ":tabe ~/_vimrc
    endtry
endfunction

" --- STATUS BAR LINE
function CheckForQuickFixErrors()
    let error_count = len(filter(getqflist(), { k,v -> match(v.text, "error") != -1 }))
    let warning_count = len(filter(getqflist(), { k,v -> match(v.text, "warning") != -1 }))
    if error_count != 0 || warning_count != 0
        copen
    endif
endfunction

function ExecMake()
    set laststatus=2
    cclose
    let g:asyncrun_open = 0
    AsyncRun -program=make
    autocmd User AsyncRunStop call CheckForQuickFixErrors()
endfunction
set statusline=%{getqflist()[-1]['text']}

" --- MY MAPPINGS ---
nnoremap  <C-K>   <ESC>:wa<CR><ESC>:call ExecMake()<CR>
inoremap  <C-K>   <ESC>:wa<CR><ESC>:call ExecMake()<CR>
"nnoremap  <C-K>   <ESC>:wa<RETURN><ESC>:AsyncRun -program=make<RETURN> 
"inoremap  <C-K>   <ESC>:wa<RETURN><ESC>:AsyncRun -program=make<RETURN> 
nnoremap  <C-N>   <ESC>:call NextQuickFixError()<RETURN>
nnoremap  <C-B>   <ESC>:call PrevQuickFixError()<RETURN>
noremap   <C-S>   <ESC><ESC>:Rg<RETURN>
nnoremap  <C-J>   <ESC><ESC>:wa<RETURN>
inoremap  <C-J>   <ESC><ESC>:wa<RETURN>

nnoremap  <C-w>v  <ESC>:vsplit<RETURN>
nnoremap  <C-w>b  <ESC>:split<RETURN>
nnoremap  <C-h>   <ESC>:set paste!<RETURN>

nnoremap  <F2>    <ESC>:w<RETURN><ESC>:source $HOME/_vimrc<RETURN>
noremap   <F3>    <ESC>:call OpenFile('~/_vimrc')<CR>
nnoremap  <F4>    <ESC>:call OpenFile('~/vimfiles/colors/custom.vim')<CR>
nnoremap  <F6>    <ESC>:call OpenFile('~/vimfiles/syntax/c.vim')<CR>

nnoremap  <F8>    <ESC>:w<RETURN><ESC>:call DisplayTags()<RETURN>
nnoremap  <F9>    <ESC>:w<RETURN><ESC>:call DisplayGivenTag()<RETURN>
nnoremap  <F10>   <ESC>:w<RETURN><ESC>:call RebuildTags()<RETURN>
"nnoremap  <F5>   <ESC>:update<RETURN><ESC>:cw<RETURN><ESC>:cn<RETURN>
"nnoremap  <F5>   <ESC>:wa<RETURN><ESC>:AsyncRun -mode=term -pos=external -focus=0 -silent ..\misc\build.bat<RETURN><CR>

" --- ASYNC COMMANDS ---
command! -nargs=1 Git   AsyncRun -mode=term -pos=right -focus=1 git <args>
command! -nargs=1 Touch AsyncRun -mode=term -pos=hide  -focus=0 type nul > <args>
command! -nargs=1 Rm    AsyncRun -mode=term -pos=hide  -focus=0 del <args>
command! -nargs=1 Mv    AsyncRun -mode=term -pos=hide  -focus=0 move <args>
command! -nargs=1 Build AsyncRun -mode=term -pos=hide  -focus=0 build.bat<RETURN><CR>
command -nargs=* Run AsyncRun <args>

" --- LOAD VIM SESSION ---
set sessionoptions=tabpages,curdir,winpos,winsize,unix
function LoadSession() abort
    silent! :source ../session.vim
endfunction
if !v:vim_did_enter " only on vim enter do I load the session
 call LoadSession()
endif
