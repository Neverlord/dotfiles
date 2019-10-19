" -- general settings --------------------------------------------------------

set autoindent                     " start lines at consistent indent
set background=light               " bright terminal background
set backspace=indent,eol,start     " backspacing over everything in insert mode
set colorcolumn=80                 " draw a line at 80 character limit
set copyindent                     " copy the structure of existing indentation
set expandtab                      " expand tabs to spaces
set formatoptions=tcrqn            " see :h 'fo-table
set hidden                         " allow putting dirty buffers in background
set history=1024                   " longer command history
set ignorecase                     " case-insensitive search
set incsearch                      " jumps to search word as you type
set listchars=eol:¶,tab:→ ,space:· " use more familiar 'visible characters'
set modeline                       " enable modelines
set nocompatible                   " don't try to be compatible to Vi
set nojoinspaces                   " void two spaces when joining strings
set nowrap                         " disable auto-wrapping of lines
set number                         " show line number for the current position
set relativenumber                 " show line numbers relatively position
set shiftwidth=2                   " tab indention
set smartcase                      " override ignorecase when using uppercase
set spellfile=~/.vim/spellfile.add " file to our spelling file
set spelllang=en,de                " german and english spell checking
set t_Co=256                       " use wider color range
set t_vb=                          " no audible bell
set tabstop=2                      " number of spaces for a <Tab>
set textwidth=80                   " use 80 characters for wrapping
set virtualedit=block              " move to empty spaces in block mode
set visualbell                     " enable visual bell
set wildmode=longest,list:full     " how to complete <Tab> matches

let g:find_in_files="tex,txt,md,cc,cpp,hh,hpp,h"  " file endings for :Find
let g:solarized_termcolors=256                    " use wider color range let

scriptencoding utf-8           " make sure we use a sane file format

" -- indentation tweaks ------------------------------------------------------

" l1  = align with case label isntead of steatement after it in the same line.
" N-s = Do not indent namespaces.
" t0  = do not indent a function's return type declaration.
" (0  = line up with next non-white character after unclosed parentheses...
" W2  = ...but not if the last character in the line is an open parenthesis.
set cinoptions=l1,N-s,t0,(0,W2

" -- save/load hooks ---------------------------------------------------------

" remove trailing spaces when saving a file
autocmd BufWritePre * %s/\s\+$//e

" -- custom functions and commands -------------------------------------------

" Find a string in all *.hpp and *.cpp files
function! F(what)
  silent execute "grep -R --exclude-dir={build,bundle} '--include=*.'{" .
  \              g:find_in_files . "} \"" . a:what . "\" ."
  execute "normal! \<C-O>:copen\<CR>\<C-W>\<S-J>"
  execute "normal! :redraw!\<CR>"
endfunction

command! -nargs=* Find call F('<args>')

" -- key binding -------------------------------------------------------------

" rebind CTRL+B to make
map <C-B> :wa<CR>:make!<CR>
inoremap <C-B> <ESC>:wa<CR>:make!<CR>

" rebind SHIFT+B to open build messages
noremap <S-B> :copen<CR><C-W><S-J>

" rebind CTRL+N for jumping to the next error/warning
map <C-N> :cnext<CR>

" rebind CTRL+K for auto-formatting via clang-format
if has('python3')
  map <C-K> :py3f ~/.vim/modules/clang-format.py<CR>
else
  map <C-K> :pyf ~/.vim/modules/clang-format.py<CR>
endif

" map CTRL+F to the custom command ':Find '
map <C-F> <ESC>:Find<Space>
imap <C-F> <ESC>:Find<Space>

" avoid hitting <ESC> dozens of times a day
inoremap jk <ESC>

" automatically clear last search highlight whenever pressing <enter>
nnoremap <CR> :noh<CR><CR>

" -- leader shortcuts --------------------------------------------------------

let mapleader = ' '

" rebind Leader+R to run current project via run.sh script
nnoremap <leader>r :!./run.sh<CR>

" rebind Leader+S for sorting a selected range
xnoremap <leader>s :sort<CR>

" -- auto commands -----------------------------------------------------------

" recognize doxygen comments in C++ files
autocmd BufEnter,BufNew *.[hc]pp,*.hh,*.cc set comments=:///,://!,://

" enable spell checking for text files
autocmd Filetype tex,markdown set spell

" -- plugins -----------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" adds IDE-like file views in current path on the left
Plug 'scrooloose/nerdtree'

" allows fuzzy-search when opening files
Plug 'kien/ctrlp.vim'

let g:ctrlp_custom_ignore = 'build/'  " ignore build directories
let g:ctrlp_max_depth=20              " increase number of searched subfolders
let g:ctrlp_max_files=0               " scan all files in a directory
let g:ctrlp_root_markers = ['.ctrlp'] " go up until hitting a .ctrlp file

" adds auto-completion for brackets
Plug 'jiangmiao/auto-pairs'

" adds a status/tabline to VIM
Plug 'vim-airline/vim-airline'

" themes for the status line
Plug 'vim-airline/vim-airline-themes'

let g:airline#extensions#tabline#enabled=2     " show open buffers
let g:airline#extensions#tabline#fnamemod=':t' " omit path to current file
let g:airline_powerline_fonts=1                " use powerline symbols
let g:airline_theme='solarized'                " fit our color scheme

" allows to easily add parens or quotes around selected text
Plug 'tpope/vim-surround'

call plug#end()
