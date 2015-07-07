" vim:fdm=marker
au!

set nocompatible

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!executable('xdg-open') &&
      \     system('uname') =~? '^darwin'))

if s:is_windows
  echom "You're gonna have a bad time.a"
endif

" Plugins {{{
call plug#begin('~/.vim/plugged')

" Dependencies {{{
" VimProc
function! BuildVimProc(info)
  if a:info.status == 'installed' || a:info.force
    if s:is_cygwin
      !make -f make_cygwin.mak
    elseif s:is_mac
      !make -f make_mac.mak
    elseif !s:is_windows
      !make
    endif
  endif
endfunction
Plug 'Shougo/vimproc.vim', { 'do': function('BuildVimProc') }
" }}}

" Visuals {{{
Plug 'altercation/vim-colors-solarized'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'itchyny/lightline.vim'
" }}}

" Utilities {{{
Plug 'rking/ag.vim'
Plug 'Shougo/unite.vim', { 'depends': 'Shougo/vimproc' }
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession', { 'depends': 'tpope/vim-obsession' }
" }}}

" Formatting {{{
Plug 'junegunn/vim-easy-align'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'editorconfig/editorconfig-vim'
" }}}

" Shell {{{
Plug 'dag/vim-fish'
Plug 'kelan/gyp.vim'
" }}}

" Web {{{
Plug 'ap/vim-css-color'
Plug 'othree/html5.vim', { 'for': ['html', 'xml'] }
Plug 'Valloric/MatchTagAlways', { 'for': ['html', 'xml'] }
Plug 'docunext/closetag.vim', { 'for': ['html', 'xml'] }
" }}}

" Markdown {{{
function! PatchLivedown(info)
  " Patch livedown to handle cygwin paths when using windows nodejs (nodejs
  " doesn't support cygwin)
  if s:is_cygwin
    if a:info.status == 'installed' || a:info.force
      !curl -sL http://git.io/vtjLp | patch -p1
      redraw
    endif
  endif
endfunction

Plug 'shime/vim-livedown', {
      \ 'do': function('PatchLivedown'),
      \ 'for': 'markdown'
      \ }
" }}}

" Haskell {{{
Plug 'yogsototh/haskell-vim'
Plug 'pbrisbin/vim-syntax-shakespeare'
" See https://github.com/kazu-yamamoto/ghc-mod/wiki/InconsistentCabalVersions
Plug 'eagletmt/ghcmod-vim', {
      \ 'do': 'cabal install ghc-mod --constraint \"Cabal<1.22\" cabal-install',
      \ 'for': 'haskell'
      \ }
Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
" }}}

" C++ {{{
Plug 'vim-scripts/cmake.vim-syntax'

if !s:is_cygwin
  function! BuildYCM(info)
    if a:info.status == 'installed' || a:info.force
      !./install.sh
    endif
  endfunction

  Plug 'Valloric/YouCompleteMe', {
        \ 'do': function('BuildYCM'),
        \ 'for': ['c', 'cpp']
        \ }
  " Necessary for on-demand loading with YCM
  " See https://github.com/junegunn/vim-plug/issues/149#issuecomment-103597834
  autocmd! User YouCompleteMe call youcompleteme#Enable()
else
  " YouCompleteMe doesn't work on Cygwin, so fall back to vim-marching for C++
  " completion.
  Plug 'osyo-manga/vim-marching', {
        \ 'depends': ['Shougo/vimproc.vim', 'osyo-manga/vim-reuinions'],
        \ 'for': ['c', 'cpp']
        \ }
endif
" }}}

call plug#end()
" }}}

" Basic Options {{{
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
set listchars=eol:¬,tab:->
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
  hi ColorColumn ctermbg=15 ctermfg=0
endif

set background=dark

try
  colorscheme solarized
catch
endtry
" }}}

" Plugin Configuration {{{
" Indent Guides {{{
let g:indent_guides_guide_size=&tabstop
" }}}

" Trailing Whitespace {{{
let g:extra_whitespace_ignored_filetypes = ['unite', 'mkd', 'markdown', 'help']
" }}}

" Syntastic {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_mode_map={'mode': 'active', 'passive_filetypes': ['haskell']}

nmap <silent> <leader>hl :SyntasticCheck hlint<cr>:lopen<cr>
" }}}

" Ghc-mod {{{
nmap <silent> <leader>ht :GhcModType<CR>
nmap <silent> <leader>hh :GhcModTypeClear<CR>
nmap <silent> <leader>hT :GhcModTypeInsert<CR>
nmap <silent> <leader>hc :SyntasticCheck ghc_mod<CR>:lopen<CR>
" Check Haskell on write
autocmd BufWritePost *.hs,*.lhs GhcModCheckAndLintAsync
" }}}

" Neco-ghc {{{
autocmd BufEnter *.hs,*.lhs let g:neocomplcache_enable_at_startup = 1
function! SetToCabalBuild()
  if glob("*.cabal") != ''
    set makeprg=cabal\ build
  endif
endfunction
autocmd BufEnter *.hs,*.lhs :call SetToCabalBuild()

let $PATH=$PATH.':'.expand("~/.cabal/bin")
" }}}

" YouCompleteMe {{{
if s:is_mac
  let g:ycm_global_ycm_extra_conf='~/.vim/YCM/conf/default-libc++.py'
else
  let g:ycm_global_ycm_extra_conf='~/.vim/YCM/conf/default-libstdc++.py'
endif

let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_insertion=1

" Use neco-ghc for Haskell files
let g:ycm_semantic_triggers = {'haskell' : ['.']}
" }}}

" Marching {{{
let g:marching_include_paths = filter(
      \ split(glob('/usr/include/c++/*/'), '\n') +
      \ split(glob('/usr/include/*/c++/*/'), '\n') +
      \ split(glob('/usr/include/*/'), '\n'),
      \ 'isdirectory(v:val)') + [
      \ 'include/',
      \ '.'
      \ ]

"let g:marching_enable_refresh_always = 1

" Don't auto-insert the first word
autocmd FileType cpp noremap <C-x><C-o> <Plug>(marching_start_omni_complete)

" Automatically complete when using scope resolution or member access
" operators.
autocmd FileType cpp inoremap :: ::<C-x><C-o>
autocmd FileType cpp inoremap . .<C-x><C-o>
autocmd FileType cpp inoremap -> -><C-x><C-o>
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
" Search for highlighted word in all files.
nmap <leader>* :Ag <c-r>=expand("<cword>")<cr><cr>
" Search all files for a given string.
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
      \   'readonly': 'LLReadonly',
      \   'modified': 'LLModified',
      \   'filename': 'LLFilename'
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }  

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
" Disable delimitMate for angle brackets on closetag files (messes with tags)
au FileType html,xhtml,xml,phtml let b:delimitMate_matchpairs = "(:),[:],{:}"
" }}}

" Tagbar {{{
"let g:tagbar_usearrows=1
"nnoremap <leader>t :TagbarToggle<CR> 
" }}}

" Livedown {{{
nnoremap <leader>md :LivedownPreview<cr>
" }}}

" EasyAlign {{{
vnoremap <silent> <Enter> :EasyAlign<cr>
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

  " Filetypes
  " CMake
  au BufNewFile,BufReadPost *.cmake,CMakeLists.txt set filetype=cmake
  " Markdown
  au BufNewFile,BufReadPost *.md set filetype=markdown
  " Editorconfig
  au BufNewFile,BufReadPost .editorconfig set filetype=sh
  " SCons
  au BufNewFile,BufReadPost SCons* set filetype=python

  " Show absolute line numbers in insert mode or when out of focus.
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

    " Set indent guides size as well.
    let g:indent_guides_guide_size=a:size
  else
    echom "ERROR: Tab size must be greater than 0."
  endif
endfunction
" }}}

" Mappings {{{
" Visual {{{
" Align things

" Move visual selection with arrow keys.
vmap <left> <gv
vmap <right> >gv
vmap <up> [egv
vmap <down> ]egv
" }}}

" Normal {{{
" Remap window functions to <leader>w
nnoremap <leader>w <C-w>
" Re-source .vimrc
nnoremap <leader>rc :source ~/.vimrc<cr>

" Change tab sizes quick and easily
" Little tabs (2)
nnoremap <leader>tl :call TabSize(2)<cr>
" Medium tabs (4)
nnoremap <leader>tm :call TabSize(4)<cr>
" Big tabs (8)
nnoremap <leader>tb :call TabSize(8)<cr>

" Move current line with arrow keys.
nmap <left> <<
nmap <right> >>
nmap <up> [e
nmap <down> ]e
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
