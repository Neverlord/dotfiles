" -- General settings --------------------------------------------------------

set nocompatible        " iMproved.

set autoindent          " Copy indent from current line on starting a new line.
set backspace=indent,eol,start " Backspacing over everything in insert mode.
set hidden              " Allow for putting dirty buffers in background.
set history=1024        " Lines of command history
set ignorecase          " Case-insensitive search
set incsearch           " Jumps to search word as you type.
set smartcase           " Override ignorecase when searching uppercase.
set modeline            " Enables modelines.
set wildmode=longest,list:full " How to complete <Tab> matches.
set virtualedit=block   " Support moving in empty space in block mode.

" Low priority for these files in tab-completion.
set suffixes+=.aux,.bbl,.blg,.dvi,.log,.pdf,.fdb_latexmk     " LaTeX
set suffixes+=.info,.out,.o,.lo

set viminfo='20,\"500

" No header when printing.
set printoptions+=header:0

" No audible bell
set visualbell
set t_vb=

" Remove trailing spaces when saving a file.
autocmd BufWritePre * %s/\s\+$//e

" Make sure we use a sane file format.
scriptencoding utf-8

" rebind :make to Ninja if a Ninja build file exists
if filereadable("./build/build.ninja") || filereadable("./build.ninja")
  set makeprg=ninja
endif

set printoptions=number:y

" -- Key binding -------------------------------------------------------------

" Rebind CTRL+B to build current project.
if filereadable("./build/build.ninja") || filereadable("./build/Makefile")
  map <C-B> :wa<CR>:make! -C build<CR>
  inoremap <C-B> <ESC>:wa<CR>:make! -C build<CR>
else
  map <C-B> :wa<CR>:make!<CR>
  inoremap <C-B> <ESC>:wa<CR>:make!<CR>
endif

" Rebind CTRL+M to open build messages.
noremap <S-B> :copen<CR><C-W><S-J>

" Rebind CTRL+N for jumping to the next error/warning.
map <C-N> :cnext<CR>

" Rebind CTRL+L for applying Clang-suggested fixes.
map <C-L> :YcmCompleter FixIt<CR>
inoremap <C-L> :YcmCompleter FixIt<CR>

" rebind CTRL+K for auto-formatting.
if has('python3')
  map <C-K> :py3f ~/.vim/modules/clang-format.py<CR>
else
  map <C-K> :py ~/.vim/modules/clang-format.py<CR>
endif

let mapleader = ' '

" Clear last search highlighting.
nnoremap <CR> :noh<CR><CR>

" Toggle list mode (display unprintable characters).
nnoremap <F11> :set list!<CR>

" Avoid hitting <ESC> dozens of times a day.
inoremap jk <ESC>

" Toggle paste mode.
set pastetoggle=<F12>

" Remove trailing whitespace.
nmap <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

" Indent entire file.
nmap <leader>= :call Preserve("normal gg=G")<CR>

" Highlight text last pasted.
nnoremap <expr> <leader>p '`[' . strpart(getregtype(), 0, 1) . '`]'

" -- Leader shortcuts --------------------------------------------------------

let mapleader=" "

" rebind Leader+R to run current project via run.sh script
nnoremap <leader>r :!./run.sh<CR>

" rebind Leader+S for sorting a selected range
xnoremap <leader>s :sort<CR>

" -- Styling -----------------------------------------------------------------

set colorcolumn=80      " Draw a line at 80 character limit"
set background=light    " Syntax highlighting for a bright terminal background.
set hlsearch            " Highlight search results.
set ruler               " Show the cursor position all the time.
set showbreak=…         " Highlight non-wrapped lines.
set showcmd             " Display incomplete command in bottom right corner.
set relativenumber
set number
set nowrap

if has('gui_running')
  set columns=80
  set lines=25
  set guioptions-=T   " Remove the toolbar.
  set guifont=Anonymous\ Pro\ for\ Powerline:h12
  "set transparency=5

  " Disable MacVim-specific Cmd/Alt key mappings.
  if has("gui_macvim")
    let macvim_skip_cmd_opt_movement = 1
  endif
else
  set t_Co=256        " We use 256 color terminal emulators these days.
endif

" Folding
if version >= 600
    set foldenable
    set foldmethod=marker
endif

" -- Formatting --------------------------------------------------------------

set formatoptions=tcrqn " See :h 'fo-table for a detailed explanation.
set nojoinspaces        " Don't insert two spaces when joining after [.?!].
set copyindent          " Copy the structure of existing indentation
set expandtab           " Expand tabs to spaces.
set tabstop=2           " number of spaces for a <Tab>.
set shiftwidth=2        " Tab indention

" Indentation Tweaks.
" l1  = align with case label isntead of steatement after it in the same line.
" N-s = Do not indent namespaces.
" t0  = do not indent a function's return type declaration.
" (0  = line up with next non-white character after unclosed parentheses...
" W2  = ...but not if the last character in the line is an open parenthesis.
set cinoptions=l1,N-s,t0,(0,W2

" -- Spelling ----------------------------------------------------------------

if has("spell")
  set spelllang=en,de
  set spellfile=~/.vim/spellfile.add
endif

" -- Key Bindings ------------------------------------------------------------

" -- Custom Functions --------------------------------------------------------

" Find a string in all *.hpp and *.cpp files
function! F(what)
  silent execute 'grep -R --exclude-dir=build --include="*.tex" --include="*.txt" --include="*.cc" --include="*.cpp" --include="*.hh" --include="*.hpp" "' . a:what . '" .'
  execute "normal! \<C-O>:copen\<CR>\<C-W>\<S-J>"
  execute "normal! :redraw!\<CR>"
endfunction

command! -nargs=* Find call F('<args>')

" map CTRL+F to ':Find ''
map <C-F> <ESC>:Find<Space>
imap <C-F> <ESC>:Find<Space>

let g:addClassScript = getcwd() . "/add_class"

if filereadable(g:addClassScript)
  if has('python3')
    python3 import sys, vim
    python3 sys.argv = ["vim"]
    execute "py3file " . g:addClassScript
  else
    python import sys, vim
    python sys.argv = ["vim"]
    execute "pyfile " . g:addClassScript
  endif
  let g:hasAddClass = 1
else
  let g:hasAddClass = 0
endif

function! AddClassFun(name)
  if g:hasAddClass
    if has('python3')
      py3 add_class_by_name(False, vim.eval('a:name'))
    else
      py add_class_by_name(False, vim.eval('a:name'))
    endif
    ClearAllCtrlPCaches
  endif
endfunction

command! -nargs=* AddClass call AddClassFun('<args>')

map <leader>n :AddClass

function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business.
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Customize solarized color scheme.
let g:solarized_menu = 0
let g:solarized_termtrans = 1
let g:solarized_contrast = 'high'
let g:solarized_contrast = 'high'
let g:solarized_hitrail = 1
if !has('gui_running')
  let g:solarized_termcolors = 256
end
colorscheme solarized

" Active lightline.
set laststatus=2

let vimrplugin_notmuxconf = 1 "do not overwrite an existing tmux.conf.
let vimrplugin_assign = 0     "do not replace '_' with '<-'.
let vimrplugin_vsplit = 1     "split R vertically.

" Needs to be executed after Vundle.
filetype plugin indent on

" -- Filetype Stuff ----------------------------------------------------------

if &t_Co > 2 || has('gui_running')
  syntax on
endif

" R stuff
autocmd BufNewFile,BufRead *.[rRsS] set ft=r
autocmd BufRead *.R{out,history} set ft=r

autocmd BufRead,BufNewFile *.dox      set filetype=doxygen
autocmd BufRead,BufNewFile *.mail     set filetype=mail
autocmd BufRead,BufNewFile *.bro      set filetype=bro
autocmd BufRead,BufNewFile *.pac2     set filetype=ruby
autocmd BufRead,BufNewFile *.ll       set filetype=llvm
autocmd BufRead,BufNewFile *.kramdown set filetype=markdown
autocmd BufRead,BufNewFile Portfile   set filetype=tcl

" Respect (Br|D)oxygen comments.
autocmd FileType c,cpp set comments-=://
autocmd FileType c,cpp set comments+=:///
autocmd FileType c,cpp set comments+=://
autocmd FileType bro set comments-=:#
autocmd FileType bro set comments+=:##
autocmd FileType bro set comments+=:#
autocmd Filetype mail set sw=4 ts=4 tw=72
autocmd Filetype tex set iskeyword+=:

" Bro-specific coding style.
augroup BroProject
  autocmd FileType bro set noexpandtab cino='>1s,f1s,{1s'
  au BufRead,BufEnter ~/work/bro/**/*{cc,h} set noexpandtab cino='>1s,f1s,{1s'
augroup END

if has("spell")
  autocmd BufRead,BufNewFile *.dox  set spell
  autocmd Filetype mail             set spell
  autocmd Filetype tex              set spell
endif

" -- plugins -----------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" Adds IDE-like file views in current path on the left.
Plug 'scrooloose/nerdtree'

" Allows fuzzy-search when opening files.
Plug 'kien/ctrlp.vim'

" Have CTRL+P scan all files in a directory.
let g:ctrlp_max_files=0

" Recursively scan up to 100 directories.
let g:ctrlp_max_depth=100

" Ignore build directories in CTRLP.
let g:ctrlp_custom_ignore = 'build/'

" Scan for directories with a '.ctrlp' file as root.
let g:ctrlp_root_markers = ['.ctrlp']

" Disable caching.
" let g:ctrlp_use_caching = 0

" Adds auto-completion for brackets.
Plug 'jiangmiao/auto-pairs'

" Adds a status/tabline to VIM.
Plug 'vim-airline/vim-airline'

" Themes for the status line.
Plug 'vim-airline/vim-airline-themes'

" Prettify status line.
let g:airline#extensions#tabline#enabled = 2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme= 'solarized'

" Allows to easily add parens or quotes around selected text.
Plug 'tpope/vim-surround'

" Allows swapping contents of splits.
Plug 'wesQ3/vim-windowswap'

" Allows editing of .aes file via OpenSSL.
Plug 'vim-scripts/openssl.vim'

call plug#end()
