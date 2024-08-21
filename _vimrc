" --- WISH LIST ---
"  - FZF colors, why, why do you pain me
"  - Jump to definition ctrl + [] to jump to and from
"  - always center quickfix window highlighted line
"  - have only 1 quickfix window open at any given time
"  - syntax highlighting for types
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
Plugin 'ctrlpvim/ctrlp.vim'       " file finder - not using for now, seeing if I like fzf better
Plugin 'scrooloose/nerdtree'      " file viewer with tab
Plugin 'skywind3000/asyncrun.vim' " run terminal commands from vim
Plugin 'haya14busa/incsearch.vim' " improved hlsearch, cant backspace while shift T_T
Plugin 'webastien/vim-ctags'      " jump to definition (not working)
Plugin 'junegunn/fzf'             " just used for ripgrep. Idk if I want this, seems annoying
Plugin 'junegunn/fzf.vim'         " just used for ripgrep. Idk if I want this, seems annoying
Plugin 'jansedivy/jai.vim'        " jai syntax highlighting
call vundle#end()            " required
filetype plugin indent on    " required

" --- GVIM SETTINGS ---
set guioptions-=M  "remove menu bar
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions+=r  "remove right scroll bar
set guioptions+=R  "remove right scroll bar
set guioptions-=l  "remove left scroll bar
set guioptions-=L  "remove left scroll bar
set guioptions-=b  "remove bottom scroll bar
set guioptions-=e  "tab bar fix
set guioptions+=a  "gvim copy to system clipboard, on select
set guioptions+=d  "try and use dark theme

" --- TEXT SETTINGS ---
set scrolloff=0
set belloff=all " thank jebus no ding dings
set ai          " automatic indent
set si          " smart indent
set is          " smart indent
set ts=4        " tab space
set ss=4
set sw=4
set siso=4
set expandtab
set softtabstop=4 " make the spaces feel like real tabs
set backspace=indent,eol,start
set nocompatible  " make vim more compatible with Vi, or not.
set autoread      " auto read changes to files
set incsearch
set hlsearch

" --- GENERAL SETTINGS
set termguicolors " tell vim to use gui colors rather than cterm colors
set guifont=consolas:h11
colorscheme custom
set splitright " direction to split
set splitbelow " direction to split
set ruler      " turn on ruler
set nopaste    " turn off paste
set nonumber   " enables line numbers
set mouse=a    "enable mouse functionality
set nohlsearch "disable highlighting after search complete
set wrap linebreak nolist
set guicursor+=a:blinkon0 "disable blinking cursor
set foldcolumn=0  "remove all empty spaces on the left
set cinoptions=l1 " fix indentation problems as case:{
syntax on      " sytax highlighting on 

" --- Remove trailing whitespace for these file types
autocmd FileType c,cpp,python autocmd BufWritePre <buffer> %s/\s\+$//e

" --- NERDTREE SETTINGS ---
:nnoremap <tab> :NERDTreeToggle<CR>
let g:NERDTreeTabsTabMotion = 1
let NERDTreeShowHidden=1
let NERDTreeRespectWildIgnore=1
let NERDTreeQuitOnOpen=0
let NERDTreeMinimalUI=1
let NERDTreeMinimalMenu=1
let NERDTreeHighlightCursorline=1
let NERDTreeAutoCenter=1

" --- INCSEARCH ---
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" --- ASYNC SETTINGS ---
let g:asyncrun_open = 0
let g:asyncrun_stdin = 1
let g:asyncrun_save = 1
let g:asyncrun_auto = "make"
let g:asyncrun_status = ""

" --- C TAGS ---

" --- FZF RG SETTINGS --- why so trash when it comes to preview colors\
let g:fzf_layout = {'down': '40%'}
let g:fzf_colors =                                                                         
    \ { 'fg':      ['fg', 'Normal'],                                                           
      \ 'bg':      ['bg', 'Comment'],                                                           
      \ 'hl':      ['fg', 'Comment'],                                                          
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],                             
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],                                       
      \ 'hl+':     ['fg', 'Statement'],                                                        
      \ 'info':    ['fg', 'PreProc'],                                                          
      \ 'border':  ['fg', 'Ignore'],                                                           
      \ 'prompt':  ['fg', 'Conditional'],                                                      
      \ 'pointer': ['fg', 'Exception'],                                                        
      \ 'marker':  ['fg', 'Keyword'],                                                          
      \ 'spinner': ['fg', 'Label'],                                                            
      \ 'header':  ['fg', 'Comment'] }

" --- OPEN/JUMPTO FILE ----
function OpenFile(filename) 
    try
        execute 'tab sbuffer ' . a:filename
    catch /E94:/
        execute 'tabe ' . a:filename
    endtry
endfunction

" --- QUICKFIX SETTINGS ---
set makeprg=..\misc\build.bat " set default make for quickfix to be my build.bat
set switchbuf=newtab,usetab " quick fix jump to existing tab or open new tab for file
"set errorformat=\ %#%f(%l\\\,%c):\ %m " clang-cl error format
set errorformat=%f(%l):\ %m,
               \%f(%l)\ :\ %m

function! NextQuickFixError() abort
    "set laststatus=0
    let error_count = len(filter(getqflist(), { k,v -> match(v.text, "error") != -1 }))
    let warning_count = len(filter(getqflist(), { k,v -> match(v.text, "warning") != -1 }))
    if error_count != 0 || warning_count != 0
        copen
        resize 10
        try
            cnext
        catch
            cfirst
            cnext
        endtry
    else
        :ccl
    endif
endfunction

function! PrevQuickFixError() abort
    "set laststatus=0
    let error_count = len(filter(getqflist(), { k,v -> match(v.text, "error") != -1 }))
    let warning_count = len(filter(getqflist(), { k,v -> match(v.text, "warning") != -1 }))
    if error_count != 0 || warning_count != 0
        copen
        resize 10
        try
            cprev
        catch
            clast
            cprev
        endtry
    else
        :ccl
    endif
endfunction

" --- STATUS BAR LINE ---
function OpenQuickFixIfErrorsElseClose()
    let error_count = len(filter(getqflist(), { k,v -> match(v.text, "error") != -1 }))
    let warning_count = len(filter(getqflist(), { k,v -> match(v.text, "warning") != -1 }))
    if error_count != 0 || warning_count != 0
        copen
        resize 10
        wincmd p " keep curser in prev window, not quickfix
        highlight StatusLine guifg=#d7af87 guibg=#444444
        "highlight StatusLineNC guifg=#1c1c1c guibg=#bf3c3c gui=bold
        highlight StatusLineNC guifg=#d7af87 guibg=#444444 gui=none
    else
        highlight StatusLine guifg=#d7af87 guibg=#444444
        "highlight StatusLineNC guifg=#1c1c1c guibg=#1c1c1c
        highlight StatusLineNC guifg=#d7af87 guibg=#444444 gui=none
        cclose
    endif
endfunction

function ExecMake()
    set statusline=%f\ %{getqflist()[-1]['text']}%=%-14.(%l,%c%)\ %p%%
    cclose
    let g:asyncrun_open = 0
    AsyncRun -program=make
    autocmd User AsyncRunStop call OpenQuickFixIfErrorsElseClose()
endfunction

" set statusbar
set laststatus=2
set statusline=%f\ %=%-14.(%l,%c%)\ %p%%

" --- MAPPINGS ---
nnoremap  <C-K>   <ESC>:wa<CR><ESC>:call ExecMake()<CR>
inoremap  <C-K>   <ESC>:wa<CR><ESC>:call ExecMake()<CR>

"nnoremap  <C-K>   <ESC>:wa<CR><ESC>:call ExecMake()<CR>
"inoremap  <C-K>   <ESC>:wa<CR><ESC>:call ExecMake()<CR>

nnoremap  <C-N>   <ESC>:call NextQuickFixError()<CR>
nnoremap  <C-B>   <ESC>:call PrevQuickFixError()<CR>

noremap   <C-S>   <ESC>:Rg<CR>
"noremap   <C-p>   <ESC>:Files<CR>

nnoremap  <C-J>   <ESC>:wa<CR>
inoremap  <C-J>   <ESC>:wa<CR>

inoremap  <C-C>   <ESC>

nnoremap  <C-w>v  <ESC>:vsplit<CR>
nnoremap  <C-w>b  <ESC>:split<CR>
nnoremap  <C-h>   <ESC>:set paste!<CR>

nnoremap  <F2>    <ESC>:w<CR><ESC>:source $HOME/_vimrc<CR>
noremap   <F3>    <ESC>:call OpenFile('~/_vimrc')<CR>
nnoremap  <F4>    <ESC>:call OpenFile('~/vimfiles/colors/custom.vim')<CR>
nnoremap  <F6>    <ESC>:call OpenFile('~/vimfiles/syntax/c.vim')<CR>

nnoremap  <F8>    <ESC>:w<CR><ESC>:call DisplayTags()<CR>
nnoremap  <F9>    <ESC>:w<CR><ESC>:call DisplayGivenTag()<CR>
nnoremap  <F10>   <ESC>:w<CR><ESC>:call RebuildTags()<CR>

" move lines up/down
nnoremap <C-down> :m .+1<CR>==
nnoremap <C-up> :m .-2<CR>==
inoremap <C-down> <Esc>:m .+1<CR>==gi
inoremap <C-up> <Esc>:m .-2<CR>==gi
vnoremap <C-down> :m '>+1<CR>gv=gv
vnoremap <C-up> :m '<-2<CR>gv=gv

" j/k traverse sublines for linewraps
nnoremap j gj
nnoremap k gk

" paste ontop of highlighted word
nnoremap <leader>p "_dP

" search replace the word you are on
nnoremap <leader>s :%s/<C-r><C-w>//gc<left><Left><Left>

" ctrl+d/u keeps cursor in the middle
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

inoremap <C-BS> <C-W>

" keep search results in center of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" --- COMMANDS ---
:command Hex %!xxd
:command Hexb %!xxd -r

" --- ASYNC COMMANDS ---
command! -nargs=1 Git   AsyncRun -mode=term -pos=right -focus=1 git <args>
command! -nargs=1 Touch AsyncRun -mode=term -pos=hide  -focus=0 touch <args>
command! -nargs=1 Rm    AsyncRun -mode=term -pos=hide  -focus=0 del <args>
command! -nargs=1 Mv    AsyncRun -mode=term -pos=hide  -focus=0 move <args>
command! -nargs=1 Start AsyncRun -mode=term -pos=hide  -focus=0 start <args>
command! -nargs=1 Build AsyncRun -mode=term -pos=hide  -focus=0 build.bat<CR><CR>
command  -nargs=* Run AsyncRun <args>

" --- LOAD VIM SESSION ---
set sessionoptions=tabpages,curdir,winpos,winsize,unix " only save tab and window info
function LoadSession() abort
    silent! :source ../session.vim
endfunction
if !v:vim_did_enter " only on vim enter do I load the session
 call LoadSession()
endif

" Enable c syntax highlighting for .hlsl files
au BufRead,BufNewFile *.hlsl set filetype=c

