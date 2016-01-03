" vim:fdm=marker:fdl=0
au!

set nocompatible

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!executable('xdg-open') &&
      \     system('uname') =~? '^darwin'))

if s:is_windows
  echom "You're gonna have a bad time."
endif

" Some plugins expect the following node modules to be installed:
" livedown
" eslint

" Plugins {{{
call plug#begin('~/.vim/plugged')

" Dependencies {{{
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
Plug 'w0ng/vim-hybrid'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/limelight.vim'
" }}}

" Utilities {{{
Plug 'rking/ag.vim'
Plug 'Shougo/unite.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-vinegar'
Plug 'Valloric/ListToggle'
" }}}

" Formatting {{{
Plug 'junegunn/vim-easy-align'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'editorconfig/editorconfig-vim'
" }}}

" Shell {{{
Plug 'dag/vim-fish', { 'for': 'fish' }
" }}}

" Web {{{
Plug 'ap/vim-css-color'
Plug 'othree/html5.vim', { 'for': ['html', 'xml'] }
Plug 'Valloric/MatchTagAlways', { 'for': ['html', 'xml', 'javascript.jsx', 'htmldjango', 'eruby'] }
Plug 'docunext/closetag.vim', { 'for': ['html', 'xml', 'htmldjango', 'eruby'] }
Plug 'othree/yajs.vim', { 'for': ['javascript'] }
      \ | Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }

Plug 'ternjs/tern_for_vim', {
      \ 'do': 'npm install',
      \ 'for': ['javascript', 'javascript.jsx']
      \ }

Plug 'elzr/vim-json', { 'for': ['json'] }
" }}}

" Typescript {{{
Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript'] }
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

" Ruby {{{
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby', 'eruby'] }
Plug 'tpope/vim-rvm', { 'for': ['ruby', 'eruby']  }
Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby']  }
Plug 'tpope/vim-bundler', { 'for': ['ruby', 'eruby']  }
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

" Scala {{{
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
" }}}

" Arduino {{{
Plug 'vim-scripts/Arduino-syntax-file', { 'for': ['c', 'cpp', 'arduino']}
" }}}

" C++ {{{
Plug 'vim-scripts/cmake.vim-syntax', { 'for': 'cmake' }
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }
Plug 'vhdirk/vim-cmake', { 'for': ['c', 'cpp', 'cmake'] }

" Fall back to vim-marching for C++ completion on cygwin
if s:is_cygwin
  Plug 'osyo-manga/vim-snowdrop', { 'for': ['c', 'cpp'] }
  Plug 'osyo-manga/vim-marching', { 'for': ['c', 'cpp'] }
endif
" }}}

" General Language Support {{{
Plug 'majutsushi/tagbar'
Plug 'scrooloose/syntastic'

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    " YouCompleteMe's clang support doesn't work on Cygwin.
    if s:is_cygwin
      " Also needs a patch for boost libs
      if a:info.status == 'installed' || a:info.force
        !curl -sL http://git.io/vCe12 | patch -p1
        redraw
      endif
      !python2 install.py
    else
      !python2 install.py --clang-completer --gocode-completer
    endif
  endif
endfunction

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM'), 'on': [] }

" Delay YCM startup to InsertEnter (may hang for 1-3 seconds on some machines)
augroup load_ycm
  au!
  au! InsertEnter *
        \ call plug#load('YouCompleteMe')     |
        \ if exists('g:loaded_youcompleteme') |
        \   call youcompleteme#Enable()       |
        \ endif                               |
        \ autocmd! load_ycm
augroup END
" }}}

call plug#end()
" }}}

" Basic Options {{{
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" No goddamn bells
set noeb vb t_vb=
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
" Don't open a file with all folds closed.
set foldlevelstart=20
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
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
" }}}

" Colors {{{
if !has('gui_running')
  set t_Co=256
  " Fill in background color
  set t_ut=
endif

" Show 80th column
if (exists('+colorcolumn'))
  set colorcolumn=80
  hi ColorColumn ctermbg=15 ctermfg=0
endif

set background=dark

try
  if !s:is_cygwin && !s:is_mac
    let g:hybrid_use_Xresources = 1
  endif

  colorscheme hybrid
catch
endtry
" }}}

" Plugin Configuration {{{
" Indent Guides {{{
let g:indent_guides_guide_size=&tabstop
" }}}

" Limelight {{{
nmap <Leader>ll :Limelight!!<cr>
xmap <Leader>ll :Limelight!!<cr>
let g:limelight_conceal_ctermfg = 'darkgray'
" }}}

" ListToggle {{{
let g:lt_location_list_toggle_map = '<leader>lt'
let g:lt_quickfix_list_toggle_map = '<leader>qt'
let g:lt_height = 5
" }}}

" Better Whitespace {{{
let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit', 'unite', 'qf', 'help', 'mkd', 'markdown']
" }}}

" Syntastic {{{
" Always populate errors so they show up when calling :lopen
let g:syntastic_always_populate_loc_list = 1

" Expect and use tsconfig.json for typescript projects
let g:syntastic_typescript_tsc_fname = ''

" Javascript with JSX syntax checking
let g:syntastic_javascript_checkers = ['eslint']
" For vim-jsx - highlight jsx in js files
" let g:jsx_ext_required = 0
" }}}

" Tagbar {{{
let g:tagbar_left = 1
let g:tagbar_usearrows=1
nnoremap <leader>tt :TagbarToggle<cr>
" }}}

" Ghc-mod {{{
" nmap <silent> <leader>ht :GhcModType<cr>
" nmap <silent> <leader>hh :GhcModTypeClear<cr>
" nmap <silent> <leader>hT :GhcModTypeInsert<cr>
" nmap <silent> <leader>hc :SyntasticCheck ghc_mod<cr>:lopen<cr>

" " Check Haskell on write
" au BufWritePost *.hs,*.lhs GhcModCheckAndLintAsync
" }}}

" Neco-ghc {{{
" function! SetToCabalBuild()
"   if glob("*.cabal") != ''
"     set makeprg=cabal\ build
"   endif
" endfunction

" au BufEnter *.hs,*.lhs :call SetToCabalBuild()

" let $PATH=$PATH.':'.expand("~/.cabal/bin")
" }}}

" Alternative C++ completion on Cygwin.
if s:is_cygwin
  " Snowdrop {{{
  let g:snowdrop#libclang_directory = "/usr/bin"
  let g:snowdrop#libclang_file = "cygclang.dll"

  let g:snowdrop#command_options = {
        \   "cpp" : "-std=c++1y"
        \ }

  let g:snowdrop#include_paths = {
        \ "cpp" : filter(
        \   split(glob('/usr/include/c++/*'), '\n') +
        \   split(glob('/usr/include/*/c++/*'), '\n') +
        \   split(glob('/usr/include/*/'), '\n'),
        \   'isdirectory(v:val)') + [
        \   'include/',
        \   '.'
        \   ]
        \ }
  " }}}

  " Marching {{{
  "let g:marching_backend = "snowdrop"

  let g:marching_include_paths = filter(
        \ split(glob('/usr/include/c++/*/'), '\n') +
        \ split(glob('/usr/include/*/c++/*/'), '\n') +
        \ split(glob('/usr/include/*/'), '\n') +
        \ split(glob('/lib/gcc/*-cygwin/*/include'), '\n') +
        \ split(glob('/lib/gcc/*-cygwin/*/include/c++'), '\n'),
        \ 'isdirectory(v:val)') + [
        \ 'include/',
        \ '.'
        \ ]

  let g:marching_enable_refresh_always = 1

  autocmd FileType cpp noremap <C-x><C-o> <Plug>(marching_start_omni_complete)

  " Automatically complete when using appropriate operators.
  " autocmd FileType cpp inoremap :: ::<C-x><C-o>
  " autocmd FileType cpp inoremap . .<C-x><C-o>
  " autocmd FileType cpp inoremap -> -><C-x><C-o>
  " }}}
endif

" YouCompleteMe {{{
let g:ycm_autoclose_preview_window_after_insertion = 1

if s:is_mac
  let g:ycm_global_ycm_extra_conf = '~/.vim/YCM/conf/libc++/.ycm_extra_conf.py'
else
  let g:ycm_global_ycm_extra_conf = '~/.vim/YCM/conf/libstdc++/.ycm_extra_conf.py'
endif

let g:ycm_semantic_triggers = {
      \ 'c': ['.', '->'],
      \ 'cpp': ['.', '->', '::'],
      \ 'css': ['re!.*:\s*', '::', 're!^\s+'],
      \ 'scss': ['re!.*:\s*', '::', 're!^\s+'],
      \ 'haskell' : ['.'],
      \ 'ruby' : ['.', '::'],
      \ 'typescript' : ['.', 're!:\s*'],
\ }

let g:ycm_extra_conf_vim_data = ['&filetype']
let g:ycm_confirm_extra_conf = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
" }}}

" CMake {{{
let g:cmake_c_compiler = "gcc"
let g:cmake_cxx_compiler = "g++"

let g:cmake_build_type = "DEBUG"

function! CMakeSetBuildType(type)
  let g:cmake_build_type = a:type

  echom "CMake: Build type set to " . a:type
endfunction

" Open new quickfix buffers in a new tab or switch to existing buffer.
au FileType c,cpp set switchbuf+=usetab,newtab

" Generate build files
au FileType c,cpp,cmake nnoremap <leader>bg :CMake<cr>
" Build
au FileType c,cpp,cmake nnoremap <leader>bb :make<cr>
" Clean build files
au FileType c,cpp,cmake nnoremap <leader>bc :CMakeClean<cr>
" Set build type to release
au FileType c,cpp,cmake nnoremap <leader>bsr :call CMakeSetBuildType("RELEASE")<cr>
" Set build type to debug
au FileType c,cpp,cmake nnoremap <leader>bsd :call CMakeSetBuildType("DEBUG")<cr>
" }}}

" Unite {{{
let g:unite_source_history_yank_enable = 1
try
  let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry

" Search for a file
nnoremap <leader><leader> :Unite -start-insert file_rec/async<cr>
" Reset Unite
nnoremap <leader>r <Plug>(unite_restart)
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
      \ 'colorscheme': 'jellybeans',
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

function! LLFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction
" }}}

" Closetag {{{
" Disable delimitMate for angle brackets on closetag files (messes with tags)
au FileType html,xhtml,xml,phtml let b:delimitMate_matchpairs = "(:),[:],{:}"
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
augroup vimrcExtra
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
  " Vagrantfile
  au BufNewFile,BufReadPost Vagrantfile set filetype=ruby

  " Run tests in Ruby projects
  au BufNewFile,BufReadPost *.rb,*.erb noremap <F6> :Bundle exec rake test<CR>

  " Compile typescript with <F5>
  au FileType typescript nnoremap <F5> :!tsc<CR>

  " Use tabs for Makefiles
  au BufNewFile,BufReadPost Makefile,*.mak :setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

  " Ruby completion settings
  au FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  au FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  " Breaks due to RVM currently:
  " au FileType ruby,eruby let g:rubycomplete_rails = 1

  " Complete erb tags in eruby files
  au FileType eruby let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
  au FileType eruby let b:delimitMate_quotes = "' \" ` | %"

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
