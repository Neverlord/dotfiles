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
"set tildeop             " Makes ~ an operator.
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
map <C-K> :py3f ~/.vim/modules/clang-format.py<CR>

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

" -- Styling -----------------------------------------------------------------

set colorcolumn=80      " Draw a line at 80 character limit"
set background=light    " Syntax highlighting for a bright terminal background.
set hlsearch            " Highlight search results.
set ruler               " Show the cursor position all the time.
set showbreak=…         " Highlight non-wrapped lines.
set showcmd             " Display incomplete command in bottom right corner.
set relativenumber
set number

if has('gui_running')
  set columns=80
  set lines=25
  set guioptions-=T   " Remove the toolbar.
  set guifont="Anonymous Pro":h14
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
"set softtabstop=2       " Number of spaces that a <Tab> counts for.
set shiftwidth=2        " Tab indention
"set textwidth=79        " Text width

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
  silent execute 'grep -R --include="*.cc" --include="*.cpp" --include="*.hh" --include="*.hpp" "' . a:what . '" .'
  execute "normal! \<C-O>:copen\<CR>\<C-W>\<S-J>"
  execute "normal! :redraw!\<CR>"
endfunction

command! -nargs=* Find call F('<args>')

" map CTRL+F to ':Find ''
map <C-F> <ESC>:Find 
imap <C-F> <ESC>:Find 

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

" LaTeX Suite: Prevents Vim 7 from setting filetype to 'plaintex'.
let g:tex_flavor = 'latex'

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

" Prepend CTRL on Alt-key mappings: Alt-{B,C,L,I}
"autocmd Filetype tex imap <C-M-b> <Plug>Tex_MathBF
"autocmd Filetype tex imap <C-M-c> <Plug>Tex_MathCal
"autocmd Filetype tex imap <C-M-l> <Plug>Tex_LeftRight
"autocmd Filetype tex imap <C-M-i> <Plug>Tex_InsertItem

" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff <wouter@blub.net>
augroup encrypted
    autocmd!
    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.gpg set bin
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt 2> /dev/null
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gpg set nobin
    autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost  *.gpg u
augroup END

" vim: set fenc=utf-8 sw=2 sts=2 foldmethod=marker :

" -- Plugins -----------------------------------------------------------------

" accept YCM config files without asking every single time
let g:ycm_confirm_extra_conf = 0

" close YCM preview window automatically
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

" start listing plugins
call plug#begin('~/.vim/plugged')

" IDE-like view of files in current path on the left
Plug 'scrooloose/nerdtree'

" CTRL+P for opening files with fuzzy search
Plug 'kien/ctrlp.vim'

" auto-completion for brackets
Plug 'jiangmiao/auto-pairs'

" allows to easily add parens or quotes around selected text
Plug 'tpope/vim-surround'

" allows swapping contents of splits
Plug 'wesQ3/vim-windowswap'

" allows builds in the background via :Make and :Dispatch
Plug 'tpope/vim-dispatch'

" allows editing of .aes file via OpenSSL
Plug 'vim-scripts/openssl.vim'

" code-completion engine
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status != 'unchanged'
    !./install.py --clang-completer
    endif
    endfunction
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

" Ignore build directories in CTRLP.
let g:ctrlp_custom_ignore = { 'dir': '/build/' }

" Consider any directory with a '.ctrlp' file
let g:ctrlp_root_markers = ['.ctrlp']

" done
call plug#end()

