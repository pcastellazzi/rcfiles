" ~/.vimrc

set nocompatible

set backspace=eol,indent,start
set cursorline
set encoding=utf-8
set esckeys
set fixeol
set formatoptions=cqrt
set hidden
set laststatus=2
set list listchars=eol:¬,tab:▸\ ,trail:.,precedes:<,extends:>
set ruler
set scrolloff=10
set whichwrap=<,>,h,l
set wildmenu

set autoindent smartindent
set backupdir=~/.vim/tmp/backup// directory=~/.vim/tmp/swap// undodir=~/.vim/tmp/undo//
set expandtab softtabstop=4 tabstop=4 shiftwidth=4 shiftround nowrap
set ignorecase incsearch infercase smartcase
set foldcolumn=1 foldnestmax=3 foldmethod=indent
set modeline modelines=2
set nostartofline virtualedit=all
set number numberwidth=4
set textwidth=88 colorcolumn=+1

syntax on
filetype on
filetype plugin on
filetype indent on

au BufReadPost * normal zR

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
