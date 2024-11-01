set number              " show line numbers
set wrap                " wrap lines
set encoding=utf-8      " set encoding to UTF-8 (default was "latin1")
set showmatch           " highlight matching parentheses / brackets [{()}]
set lazyredraw          " redraw screen only when we need to
set ruler               " show line and column number of the cursor on right side of statusline
syntax enable

filetype plugin indent on


"""" Tab settings

set tabstop=2           " width that a <TAB> character displays as
set expandtab           " convert <TAB> key-presses to spaces
set shiftwidth=2        " number of spaces to use for each step of (auto)indent
set softtabstop=2       " backspace after pressing <TAB> will remove up to this many spaces

set autoindent          " copy indent from current line when starting a new line
set smartindent         " even better autoindent (e.g. add indent after '{')

"""" Search settings

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set nobackup            " no backup files
set nowritebackup      	" only in case you don't want a backup file while editing
set noswapfile	       	" no swap files
set autoread           	" autoreload the file in Vim if it has been changed outside of Vim

