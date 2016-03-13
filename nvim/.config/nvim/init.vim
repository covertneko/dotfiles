" vim:fdm=marker:fdl=0
au!

" Basic Options {{{
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Backups
set backup
set undofile
set backupdir=~/.config/nvim/backup
set undodir=~/.config/nvim/undo
set directory=~/.config/nvim/swap
set title
set history=200
set ruler
set showcmd
set incsearch
set ignorecase smartcase
set omnifunc=syntaxcomplete#Complete
set foldmethod=syntax
" Don't open a file with all folds closed
set foldlevelstart=20
" Scroll buffer when cursor is within 5 lines of top/bottom
set scrolloff=5
" Show relative numbers for all but current line
set number
set relativenumber
" Tabs are spaces
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
" Switch to window/tab if opening an existing buffer
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
" Show eol/tabs
set list
set listchars=tab:\|\ ,eol:¬
" Rolodex mode
set winheight=5
:set noequalalways winminheight=5 winheight=9999 helpheight=9999
" Fix slow escape in insert mode
:set timeout timeoutlen=1000 ttimeoutlen=100

" Space as leader
let mapleader=" "

" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')

" Dependencies {{{
function! BuildVimProc(info)
  if a:info.status == 'installed' || a:info.force
    !make
  endif
endfunction

Plug 'Shougo/vimproc.vim', { 'do': function('BuildVimProc') }
" }}}

" Visuals {{{
" Hybrid Color Scheme
Plug 'w0ng/vim-hybrid'

" Indent Guides {{{
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_guide_size=&tabstop
" }}}

" LightLine {{{
Plug 'itchyny/lightline.vim'
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

" LimeLight {{{
Plug 'junegunn/limelight.vim'
nmap <leader>ll :Limelight!!<cr>
xmap <leader>ll :Limelight!!<cr>
let g:limelight_conceal_ctermfg = 'darkgray'
" }}}
" }}}

" Utilities {{{
"Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-vinegar'

" Ag {{{
Plug 'rking/ag.vim'
" Search for highlighted word in all files.
nmap <leader>* :Ag <c-r>=expand("<cword>")<cr><cr>
" Search all files for a given string.
nnoremap <leader>/ :Ag<space>
" }}}

" Unite {{{
Plug 'Shougo/unite.vim'
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

" ListToggle {{{
Plug 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<leader>lt'
let g:lt_quickfix_list_toggle_map = '<leader>qt'
let g:lt_height = 5
" }}}
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
Plug 'elzr/vim-json', { 'for': ['json'] }
Plug 'othree/yajs.vim', { 'for': ['javascript'] }
      \ | Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }

" Highlight current xml/html tag containing cursor
Plug 'Valloric/MatchTagAlways', { 'for': ['html', 'xml', 'javascript.jsx', 'htmldjango', 'eruby'] }

" Closetag {{{
" Automatically close nearest open tag when typing </
Plug 'docunext/closetag.vim', { 'for': ['html', 'xml', 'htmldjango', 'eruby'] }
" Disable delimitMate for angle brackets on closetag files (messes with tags)
au FileType html,xhtml,xml,phtml let b:delimitMate_matchpairs = "(:),[:],{:}"
" }}}
" }}}

" Typescript {{{
Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript'] }
" }}}

" Markdown {{{
" Livedown {{{
Plug 'shime/vim-livedown', { 'for': 'markdown' }
nnoremap <leader>md :LivedownPreview<cr>
" }}}
" }}}

" Elixir {{{
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }
" }}}

" C++ {{{
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }
" }}}

" CMake {{{
Plug 'vim-scripts/cmake.vim-syntax', { 'for': 'cmake' }
Plug 'vhdirk/vim-cmake'

let g:cmake_c_compiler = "gcc"
let g:cmake_cxx_compiler = "g++"

let g:cmake_build_type = "DEBUG"

function! CMakeSetBuildType(type)
  let g:cmake_build_type = a:type

  echom "CMake: Build type set to " . a:type
endfunction

function! CMakeBuild()
  :CMake
  :make
endfunction

" Open new quickfix buffers in a new tab
au FileType c,cpp set switchbuf+=newtab

" Generate build tree and build
au FileType c,cpp,cmake nnoremap <leader><F5> :call CMakeBuild()<cr>
" Build without regenerating build tree
au FileType c,cpp,cmake nnoremap <F5> :make<cr>
" Clean build tree
au FileType c,cpp,cmake nnoremap <F6> :CMakeClean<cr>
" Set build type to release
au FileType c,cpp,cmake nnoremap <leader>ccr :call CMakeSetBuildType("RELEASE")<cr>
" Set build type to debug
au FileType c,cpp,cmake nnoremap <leader>ccd :call CMakeSetBuildType("DEBUG")<cr>
" }}}

" General Language Support {{{
" Tagbar {{{
Plug 'majutsushi/tagbar'
let g:tagbar_left = 1
let g:tagbar_usearrows=1
nnoremap <leader>tt :TagbarToggle<cr>
" }}}

" Syntastic {{{
Plug 'scrooloose/syntastic'

" Always populate errors so they show up when calling :lopen
let g:syntastic_always_populate_loc_list = 1

" Expect and use tsconfig.json for typescript projects
let g:syntastic_typescript_tsc_fname = ''

" Javascript with JSX syntax checking
let g:syntastic_javascript_checkers = ['eslint']
" For vim-jsx - highlight jsx in js files
" let g:jsx_ext_required = 0
" }}}

" YouCompleteMe {{{
function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !python2 install.py --clang-completer --gocode-completer
  endif
endfunction

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM'), 'on': [] }

" Delay YCM startup to InsertEnter to save startup time (may hang for 1-3 seconds on some machines)
augroup load_ycm
  au!
  au! InsertEnter *
        \ call plug#load('YouCompleteMe')     |
        \ if exists('g:loaded_youcompleteme') |
        \   call youcompleteme#Enable()       |
        \ endif                               |
        \ autocmd! load_ycm
augroup END

let g:ycm_autoclose_preview_window_after_insertion = 1

let g:ycm_global_ycm_extra_conf = '~/.local/lib/YouCompleteMe/.ycm_extra_conf_libstdc++.py'

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
" }}}

call plug#end()
" }}}

" Colours and Highlighting {{{
set background=dark

try
  let g:hybrid_use_Xresources = 2
  colorscheme hybrid
catch
endtry

" Pipe cursor in insert mode; block otherwise
:let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" Highlight current line number
hi CursorLineNR ctermbg=15 ctermfg=0

" Highlight 80th column background
set colorcolumn=80
hi ColorColumn ctermbg=0

" Show cursorline only in currently active window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
" }}}

" Functions {{{
" Set all relevant tab size settings
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

" Commands {{{
" Diff original file with edits
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" Autocommands {{{
augroup init_extra
  au!
  " When editing a file, jump to the last known cursor position.
  au BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Show absolute line numbers in insert mode or when out of focus.
  au InsertEnter,WinLeave,FocusLost * setlocal norelativenumber number
  au InsertLeave,WinEnter * setlocal relativenumber

  " Filetypes {{{
  " CMake
  au BufNewFile,BufReadPost *.cmake,CMakeLists.txt set filetype=cmake
  " Markdown
  au BufNewFile,BufReadPost *.md set filetype=markdown
  " Editorconfig
  au BufNewFile,BufReadPost .editorconfig set filetype=config
  " SCons
  au BufNewFile,BufReadPost SCons* set filetype=python
  " Vagrantfile
  au BufNewFile,BufReadPost Vagrantfile set filetype=ruby
  " }}}

  " TypeScript {{{
  " Compile typescript with <F5>
  au FileType typescript nnoremap <F5> :!tsc<CR>
  " }}}

  " Makefiles {{{
  " Use tabs for Makefiles
  au BufNewFile,BufReadPost Makefile,*.mak :setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
  " }}}

  " Go {{{
  " Use tabs for go
  au FileType go :setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
  " }}}

  " Ruby {{{
  " Run tests in Ruby projects with <F6>
  au BufNewFile,BufReadPost *.rb,*.erb noremap <F6> :Bundle exec rake test<CR>

  " Completion settings
  au FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  au FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  " Breaks due to RVM currently:
  " au FileType ruby,eruby let g:rubycomplete_rails = 1

  " Complete erb tags in eruby files
  au FileType eruby let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
  au FileType eruby let b:delimitMate_quotes = "' \" ` | %"
  " }}}
  " }}}
augroup END
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
" Re-source init.vim
nnoremap <leader>rc :source ~/.config/nvim/init.vim<cr>

" Clear search results
nnoremap <leader>nh :nohlsearch<cr>

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

" Terminal {{{
" Double Esc exits to normal mode
tnoremap <Esc><Esc> <C-\><C-n>
" }}}
" }}}
