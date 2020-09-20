" core configuration
  set backupdir=~/.vim/tmp/backup// directory=~/.vim/tmp/swap// undodir=~/.vim/tmp/undo//
  set nocompatible modeline modelines=2
  set autoindent smartindent
  set expandtab softtabstop=2 tabstop=2 shiftwidth=2 shiftround nowrap
  set ignorecase incsearch infercase smartcase
  set foldcolumn=1 foldnestmax=3 foldmethod=indent
  set number numberwidth=4
  set cursorline showcmd showmatch
  set nolist listchars=eol:¬,tab:▸\ ,trail:.,precedes:<,extends:>
  set ruler laststatus=2 encoding=utf-8
  set scrolloff=10 hidden
  set textwidth=78 colorcolumn=+1
  set virtualedit=all

  syntax on
  filetype on
  filetype plugin on
  filetype indent on

  au BufReadPost * normal zR
  au BufWritePre * :%s/\s\+$//e

" omni completion
  au FileType css        setl omnifunc=csscomplete#CompleteCSS
  au FileType html       setl omnifunc=htmlcomplete#CompleteTags
  au FileType javascript setl omnifunc=javascriptcomplete#CompleteJS
  au FileType python     setl omnifunc=pythoncomplete#Complete
  au FileType ruby       setl omnifunc=rubycomplete#Complete
  au FileType xml        setl omnifunc=xmlcomplete#CompleteTags

  autocmd Filetype *
    \ if &omnifunc == "" |
    \   setl omnifunc=syntaxcomplete#Complete |
    \ endif

  " decent completion behaviour
  au CursorMovedI * if pumvisible() == 0|pclose|endif
  au InsertLeave  * if pumvisible() == 0|pclose|endif
  set completeopt+=longest

" mappings
  let mapleader=","
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" auto commands
  function s:fastset(ts, cc, ...)
    let cmd_reset  = "au! FileType %s"
    let cmd_set    = "au FileType %s setl ai et si sta ts=%d sw=%d sts=%d tw=%d"

    for ft in a:000
      exec printf(cmd_reset, ft)
      exec printf(cmd_set, ft, a:ts, a:ts, a:ts, a:cc)
    endfor
  endfunction
  command! -nargs=+ FastSet call s:fastset(<f-args>)

  FastSet 8 80 make
  FastSet 4 78 c cpp go java markdown perl php python rst
  FastSet 2 78 ruby scala sh text
  FastSet 2  0 css html javascript xhtml xml

" local setup
  if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
  endif
