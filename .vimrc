" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
endif


""" Options """

set autoindent
syntax enable
set background=dark
colorscheme solarized
set nu  " line numbering
set tabstop=4
set shiftwidth=4
set expandtab
set lbr " Wrap text instead of being on one line
set pastetoggle=<F12>
set autowrite " automatically write to file on buffer-change
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=2000
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
" scroll bevor hitting the edge
set scrolloff=4
set sidescroll=8

set nobackup		" do not keep a backup file, use versions instead
set nowritebackup " no backup while writing
set noswapfile    " no swap files


""" HIGHLIGHTING """

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" highlight overlength line parts
highlight OverLength ctermbg=red ctermfg=white guibg=#d70000
match OverLength /\%80v.\+/

" show trailing white space
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" alias to delete trailing white spaces
:command Dws %s/\s\+$//g

" saving of files as sudo
cmap w!! w !sudo tee > /dev/null %


""" BINDINGS """

" tab navigation
nnoremap <C-a> :tabprevious<CR>
nnoremap <C-y> :tabnext<CR>
nnoremap <C-t> :tabnew<CR>
inoremap <C-a> <Esc>:tabprevious<CR>i
inoremap <C-y> <Esc>:tabnext<CR>i
inoremap <C-t> <Esc>:tabnew<CR>

" Indent Python in the Google way.
source ~/.vim_python_style

" More Tabs
set tabpagemax=30
