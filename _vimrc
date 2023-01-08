" --- WISH LIST ---
"  - loading the vim session, needs to not happen when I :source ~/_vimrc
"  - Jump to definition
"  - RED and YELLOW tag colors hurt my eyes, find something better
"  - quickfix horizonal split is kind of annoying. Need to think of how to improve it.
"       1) horizontal split doesnt push the top window's text upwards, jolting
"           ths screen aroundup. Instead it needs to push the bottom of the text
"           upwards.
"       2) somehow get quickfix to, open as small as possible and show
"          doneness. If fails, then change size or reopen to larger size

"set nocompatible              "be iMproved, required
"filetype off                  "required <<========== We can turn it on later

" --- path includes (must be before plugin install) ---
set directory=$HOME/vimfiles/swapfiles/
set rtp+=$HOME/vimfiles/bundle/Vundle.vim
set rtp+=$HOME/vimfiles/colors

" --- plugin install ---
call vundle#begin()
let g:vundle#bundle_dir='$HOME/vimfiles/bundle/'
Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'haya14busa/incsearch.vim' " makes / ? g/ searching better by highlighting all results
Plugin 'webastien/vim-ctags'
"Plugin 'vim-scripts/QuickFixCurrentNumber'
"Plugin 'yssl/QFEnter' " quickfix improvements
"Plugin '907th/vim-auto-save'
"Plugin 'bimlas/vim-high'
"Plugin 'kkoenig/wimproved.vim' " this is only here to remove gvims garbage bottom and right bars because gvim couldnt use its brain to set the size of the window to the windows window size. could change a register color (maybe a background color) of some sorts but im not sure which it might be or where to find it
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

" --- GENERAL SETTINGS
set guifont=consolas:h11
"set guifont=fixedsys
colorscheme custom
set splitright
set splitbelow
set ruler
set nopaste
set number     "enables line numbers
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

" --- ASYNC SETTINGS ---
let g:asyncrun_open = 6
let g:asyncrun_stdin = 1
let g:asyncrun_save = 1
let g:asyncrun_auto = "make"
let g:asyncrun_status = ""

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

" --- QUICKFIX SETTINGS ---
set errorformat=\ %#%f(%l\\\,%c):\ %m " quick fix error format for clang/msvc (hopefully)
set makeprg=build.bat
fu! NextQuickFixError()
    try
        :cnext
    catch
        :cfirst
        :cnext
    endtry
endfunction
nnoremap <silent> <C-N>  <ESC>:call NextQuickFixError()<RETURN><ESC>

" --- COMMANDS ---
:command Hex %!xxd
:command Hexb %!xxd -r

" --- MAPPINGS ---
nnoremap j gj
nnoremap k gk

nnoremap <silent> <C-K>  <ESC>:wa<RETURN><ESC>:AsyncRun -mode=async ..\misc\build.bat<RETURN>
inoremap <silent> <C-K>  <ESC>:wa<RETURN><ESC>:AsyncRun -mode=async ..\misc\build.bat<RETURN>
nnoremap <silent> <C-J>  <ESC><ESC>:wa<RETURN>
inoremap <silent> <C-J>  <ESC><ESC>:wa<RETURN>

nnoremap <silent> <C-w>v <ESC>:vsplit<RETURN>
nnoremap <silent> <C-w>b <ESC>:split<RETURN>
nnoremap <silent> <C-h>  <ESC>:set paste!<RETURN>
nnoremap <silent> <F2>   <ESC>:source $HOME/_vimrc<RETURN>
nnoremap <silent> <F3>   <ESC>:tabedit $HOME/_vimrc<RETURN>
nnoremap <silent> <F4>   <ESC>:tabedit $HOME/vimfiles/colors/custom.vim <RETURN>
nnoremap <silent> <F8>   <ESC>:w<RETURN><ESC>:call DisplayTags()<RETURN>
nnoremap <silent> <F9>   <ESC>:w<RETURN><ESC>:call DisplayGivenTag()<RETURN>
nnoremap <silent> <F10>  <ESC>:w<RETURN><ESC>:call RebuildTags()<RETURN>
"nnoremap <silent> <F5>   <ESC>:update<RETURN><ESC>:cw<RETURN><ESC>:cn<RETURN>
"nnoremap <silent> <F5>   <ESC>:wa<RETURN><ESC>:AsyncRun -mode=term -pos=external -focus=0 -silent ..\misc\build.bat<RETURN><CR>

" --- ASYNC COMMANDS ---
command! -nargs=1 Git   AsyncRun -mode=term -pos=right -focus=1 git <args>
command! -nargs=1 Touch AsyncRun -mode=term -pos=hide  -focus=0 type nul > <args>
command! -nargs=1 Rm    AsyncRun -mode=term -pos=hide  -focus=0 del <args>
command! -nargs=1 Mv    AsyncRun -mode=term -pos=hide  -focus=0 move <args>
command! -nargs=1 Build AsyncRun -mode=term -pos=hide  -focus=0 build.bat<RETURN><CR>
command! -nargs=1 Run   AsyncRun -mode=term -pos=hide  -focus=0 run.bat<RETURN><CR>

" --- LOAD VIM SESSION ---
let timer = timer_start(1, 'LoadSession', {})
function! LoadSession(timer)
    silent! :source ../session.vim
endfunction
