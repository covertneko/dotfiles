" vim:fdm=marker
au!

" Plugins {{{
call plug#begin('~/.vim/plugged')

" Colors
Plug 'altercation/vim-colors-solarized'
Plug 'ap/vim-css-color'
Plug 'vim-scripts/cmake.vim-syntax'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'dag/vim-fish'

" Formatting
Plug 'junegunn/vim-easy-align'
Plug 'bronson/vim-trailing-whitespace'
Plug 'docunext/closetag.vim'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'

" Unite
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite.vim'
Plug 'rking/ag.vim'

" Etc
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'shime/vim-livedown'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession', { 'depends': 'tpope/vim-obsession' }
Plug 'dhruvasagar/vim-dotoo'

call plug#end()
" }}}

"Helptags

" Basic Options {{{
set nocompatible
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" No goddamn beeps
set visualbell
" Backups
set backup
set undofile
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
set directory=~/.vim/swap//
set title
set history=100
set ruler
set showcmd
set incsearch
set ignorecase smartcase
set omnifunc=syntaxcomplete#Complete
set foldmethod=syntax
set scrolloff=5
" Show line number of current line but relative for all others
set number
set relativenumber
" Tabs/indents
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set switchbuf=useopen
set showtabline=2
set modeline
set modelines=1
set winwidth=79
set splitbelow
set wrap
set formatoptions=crnj1
set sessionoptions+=winpos sessionoptions+=resize
set shortmess=atT
" Smarter command completion
set wildmenu
set wildmode=list:longest,full
" Show eol
set list
set listchars=eol:¬
" Rolodex mode
set winheight=5
:set noequalalways winminheight=5 winheight=9999 helpheight=9999
" Fix slow escape in insert mode
:set timeout timeoutlen=1000 ttimeoutlen=100

let mapleader=" "
" }}}

" Fix fish shell incompatability
if &shell =~# 'bin/fish$'
  set shell=/bin/sh
endif

" Cursor {{{
if has('mouse')
  set mouse=a
endif

" Highlight current line number
hi CursorLineNR ctermbg=15 ctermfg=0

" Cursorline in active window only
augroup CursorLine
  au!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END
" }}}

" Colors {{{
if !has('gui_running')
  set t_Co=256
endif

" Show 80th column
if (exists('+colorcolumn'))
  set colorcolumn=80
  highlight ColorColumn ctermbg=15 ctermfg=0
endif

set background=dark

try
  colorscheme solarized
catch
endtry
" }}}

" Plugin Configuration {{{
" Indent Guides {{{
let g:indent_guides_guide_size=2
" }}}

" Trailing Whitespace {{{
let g:extra_whitespace_ignored_filetypes = ['unite', 'mkd', 'markdown']
" }}}

" YouCompleteMe {{{
let g:ycm_global_ycm_extra_conf='~/.vim/YCM/conf/global_ycm_extra_conf.py' 
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_insertion=1
" }}}

" Unite {{{
let g:unite_source_history_yank_enable = 1
try
    let g:unite_source_rec_async_command = 'ag --nocolor --nogroup -g ""'
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry

" Search for a file
nnoremap <leader><leader> :Unite -start-insert file_rec/async<cr>
" Reset Unite
:nnoremap <leader>r <Plug>(unite_restart)
" }}}

" Ag {{{
nmap <leader>* :Ag <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>/ :Ag<space>
" }}}

" Lightline {{{
set laststatus=2
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LLFugitive',
      \   'readonly': 'LLReadonly',
      \   'modified': 'LLModified',
      \   'filename': 'LLFilename'
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }  

function! LLFugitive()
  if exists('*fugitive#head')
    let _ = fugitive#head()
    return strlen(_) ? ' '._ : ''
  endif
  return ''
endfunction

function! LLModified()
  if &filetype == 'help'
    return ''
  elseif &modified
    return '+'
  elseif &modifiable
    return ''
  else
    return '-'
  endif
endfunction

function! LLReadonly()
  if &filetype == 'help'
    return ''
  elseif &readonly
    return '[ro]'
  else
    return '' 
  endif
endfunction

function! LLFilename()
  return ('' != LLReadonly() ? LLReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LLModified() ? ' ' . LLModified() : '')
endfunction
" }}}

" Closetag {{{
let g:closetag_filenames = "*.html,*.xhtml,*.xml,*.phtml"
" }}}

" Tagbar {{{
let g:tagbar_usearrows=1
nnoremap <leader>t :TagbarToggle<CR> 
" }}}

" Livedown {{{
nnoremap <leader>md :call LivedownPreview()<cr>
" }}}

" Do Too {{{
let g:dotoo#agenda#files = ['$HOME/Documents/todo/agenda.txt']
" }}}
" }}}

" etc {{{
" Commands {{{
augroup vimrcEx
  au!
  " When editing a file, jump to the last known cursor position.
  au BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Set cmake file type properly
  au BufRead,BufNewFile *.cmake,CMakeLists.txt set filetype=cmake
  " And markdown
  au BufNewFile,BufReadPost *.md set filetype=markdown

  " Set absolute numbers in insert mode or when out of focus
  au InsertEnter,WinLeave,FocusLost * setlocal norelativenumber number
  au InsertLeave,WinEnter * setlocal relativenumber
augroup END

" Diff original file with edits
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
" }}}

" Functions {{{

function! TabSize(size)
  if a:size > 0
    let &tabstop=a:size
    let &shiftwidth=a:size
    let &softtabstop=a:size
  else
    echom "ERROR: Tab size must be greater than 0."
  endif
endfunction

" }}}

" Mappings {{{
" Normal {{{
" Remap window functions to <leader>w
nnoremap <leader>w <C-w>
" Re-source .vimrc
nnoremap <leader>rc :source ~/.vimrc<cr>

" Change tab sizes quick and easily
" Little tabs (2)
nnoremap <leader>tl :call TabSize(2)
" Medium tabs (4)
nnoremap <leader>tm :call TabSize(4)
" Big tabs (8)
nnoremap <leader>tb :call TabSize(8)
" }}}
" Insert {{{
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <c-u> <c-g>u<c-u>

" Sublime-style brace indenting
inoremap {<cr> {<cr>}<c-o>O
inoremap [<cr> [<cr>]<c-o>O
inoremap (<cr> (<cr>)<c-o>O

" Ctrl-c should just be Esc
imap <c-c> <esc>
" }}}
" Command {{{
" Directory of current buffer
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" Save as root
cnoremap sudow w !sudo tee % > /dev/null
" }}}
" }}}
" }}}
