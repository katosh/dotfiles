" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

" Vundle
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" my plugins
"Plugin 'Vim-R-plugin'
"Plugin 'jalvesaq/R-Vim-runtime'
Plugin 'jalvesaq/Nvim-R'
Plugin 'screen.vim'
Plugin 'vim-pandoc/vim-rmarkdown'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'derekwyatt/vim-scala'
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'vim-scripts/diffchar.vim'
Plugin 'vim-syntastic/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" End Vundle


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
set nospell         " turns on spell check for all files

set nobackup		" do not keep a backup file, use versions instead
set nowritebackup " no backup while writing
set noswapfile    " no swap files

" More Tabs
set tabpagemax=500

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

" show overlength (80 char)
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

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

""" vim R and screen """
" Installation
"       - Place plugin file under ~/.vim/
"       - To activate help, type in vim :helptags ~/.vim/doc
"       - Place the following vim conf lines in .vimrc
" Usage
"       - Read intro/help in vim with :h vim-r-plugin or :h screen.txt
"       - To initialize vim/R session, start screen/tmux, open some *.R file in vim and then hit F2 key
"       - Object/omni completion command CTRL-X CTRL-O
"       - To update object list for omni completion, run :RUpdateObjList
" My favorite Vim/R window arrangement
"   tmux attach
"   Open *.R file in Vim and hit F2 to open R
"   Go to R pane and create another pane with C-a %
"   Open second R session in new pane
"   Go to vim pane and open a new viewport with :split *.R
" Useful tmux commands
"       tmux new -s <myname>       start new session with a specific name
"   tmux ls (C-a-s)            list tmux session
"       tmux attach -t <id>        attach to specific session
"       tmux kill-session -t <id>  kill specific session
"   C-a-: kill-session         kill a session
"   C-a %                      split pane vertically
"       C-a "                      split pane horizontally
"   C-a-o                      jump cursor to next pane
"   C-a C-o                    swap panes
"   C-a-: resize-pane -L 10    resizes pane by 10 to left (L R U D)
" Corresponding Vim commands
"   :split or :vsplit      split viewport
"   C-w-w                  jump cursor to next pane-
"   C-w-r                  swap viewports
"   C-w C-++               resize viewports to equal split
"   C-w 10+                increase size of current pane by value

" To open R in terminal rather than RGui (only necessary on OS X)
" let vimrplugin_applescript = 0
" let vimrplugin_screenplugin = 0
" For tmux support
let g:ScreenImpl = 'Tmux'
let vimrplugin_screenvsplit = 1 " For vertical tmux split
let g:ScreenShellInitialFocus = 'shell'
" instruct to use your own .screenrc file
let g:vimrplugin_noscreenrc = 1
" For integration of r-plugin with screen.vim
let g:vimrplugin_screenplugin = 1
" Don't use conque shell if installed
let vimrplugin_conqueplugin = 0
" map the letter 'r' to send visually selected lines to R
let g:vimrplugin_map_r = 1
" see R documentation in a Vim buffer
let vimrplugin_vimpager = "no"
"set expandtab
set shiftwidth=4
set tabstop=4
" start R with F2 key
map <F2> <Plug>RStart
imap <F2> <Plug>RStart
vmap <F2> <Plug>RStart
" send selection to R with space bar
vmap <Space> <Plug>RDSendSelection
" send line to R with space bar
nmap <Space> <Plug>RDSendLine
" dont replace '_' by ' <- '
let R_assign = 0
let R_in_buffer = 0
let R_applescript = 0
let R_tmux_split = 1
let R_notmuxconf = 1
" Rmd syntax highligh
let rmd_syn_hl_chunk = 1
" vimdiff colors
let g:DiffColors=100
" R syntax check by syntastic plugin
let g:syntastic_enable_r_lintr_checker = 1
let g:syntastic_r_checkers = ['lintr']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_r_lintr_linters = "with_defaults(assignment_linter = NULL, absolute_paths_linter = NULL)"
