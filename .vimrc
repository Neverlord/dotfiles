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

if has("gui_running")
  colorscheme solarized
  set guifont=AnonymicePowerline:h13
  set guicursor+=a:blinkon0
endif

let g:add_class_script_path=getcwd()."/add_class" " store path to add_class
let g:find_in_files="tex,txt,md,cc,cpp,hh,hpp,h"  " file endings for :Find
let g:load_doxygen_syntax=1                       " enable Doxygen hightlight
let g:solarized_termcolors=256                    " use wider color range

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

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-ignore-vcs\ --sort\ path
endif

function! F(what)
  if executable('rg')
    silent execute "grep '" . a:what . "' -g '!build' -g '!bundle' " .
    \              "-g '!3rdparty' -g '!zeek/aux' " .
    \              "-g '*.{" . g:find_in_files . "}'"
  else
    silent execute "grep -R --exclude-dir={build,bundle} '--include=*.'{" .
    \              g:find_in_files . "} \"" . a:what . "\" ."
  endif
 execute "normal! \<C-O>:copen\<CR>\<C-W>\<S-J>"
 execute "normal! :redraw!\<CR>"
endfunction

" Find a string in all source files
command! -nargs=* Find call F('<args>')

let g:default_style=1

function ToggleTabStyle()
  if g:default_style
    set list
    set tabstop=4
    set noexpandtab
    let g:default_style=0
  else
    set nolist
    set tabstop=2
    set expandtab
    let g:default_style=1
  endif
endfunction

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

noremap <leader>z <ESC>:call ToggleTabStyle()<CR>

if filereadable(g:add_class_script_path)
  execute 'map <leader>n :! '.g:add_class_script_path.'<Space>'
endif
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
Plug 'ctrlpvim/ctrlp.vim'

let g:ctrlp_use_caching = 0
let g:ctrlp_max_files = 0
let g:ctrlp_root_markers = ['.ctrlp']
if has('win32')
  let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'
else
  if executable('rg')
    let g:ctrlp_user_command = "rg %s --no-ignore-vcs --files --color=never " .
    \                          "-g '!build' -g '!bundle' " .
    \                          "-g '!3rdparty' -g '!*.swp'"
  else
    let g:ctrlp_user_command = 'find %s -type f'
  endif
endif

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
