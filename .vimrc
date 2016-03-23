""""" Set Color Scheme (~/.vim/colors)
colo zachVimColorsSSH

""""" Text Formatting
set autoindent " Auto indentation
set smartindent " fixed autoindent fails
set expandtab " All new tab characters will be turned to spaces.
set shiftround
set shiftwidth=2 " Set shift width to n characters
set smarttab
set tabstop=3
" Tab at start of line inserts shiftwidth spaces, elsewhere inserts tabstop spaces
" use :retab to convert all existing tab characters to match current tab
" settings.

""""" Search Formating
set ignorecase " Case insensitive search
set smartcase " Ignore's case of search only if all lowercase
set wildignore+=tmp
nnoremap <silent> <C-l> :nohl<CR><C-l> "<ctrl-l> removes highlights

" Stuff from $VIMRUNTIME\vimrc_example.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup		" keep a backup file
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
set guioptions+=t

" Remove scrollbars!
set guioptions-=L
set guioptions-=R
set guioptions-=l
set guioptions-=r

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

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
    autocmd FileType text,markdown,ruby,javascript setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

    " git commits always start on the first line.
    " From http://vim.wikia.com/wiki/Always_start_on_first_line_of_git_commit_message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
  augroup END
else

  set autoindent
  set smartindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
"" Turn off auto-comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
""""" Root Syntax enabled by ~/.vim/after/syntax/c.vim
""""" Window Swapping (in window 1, type /wm. Go to window 2, type /pw)
function! MarkWindowSwap()
  let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
  "Mark destination
  let curNum = winnr()
  let curBuf = bufnr( "%" )
  exe g:markedWinNum . "wincmd w"
  "Switch to source and shuffle dest->source
  let markedBuf = bufnr( "%" )
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' curBuf
  "Switch to dest and shuffle source->dest
  exe curNum . "wincmd w"
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' markedBuf
endfunction

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>
