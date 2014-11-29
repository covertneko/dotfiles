" vim:fdm=marker

set nocompatible

call pathogen#infect()
Helptags

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup
set undofile
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
set directory=~/.vim/swap//

set title
set history=50
set ruler
set showcmd
set incsearch
set omnifunc=syntaxcomplete#Complete 

set foldmethod=syntax
set scrolloff=5
set number
set relativenumber

set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2

set autoindent

let mapleader=" "

if has('mouse')
  set mouse=a
endif

filetype plugin indent on

" Colors {{{
syntax on

if !has('gui_running')
  set t_Co=256
endif

set background=light
let g:solarized_termtrans=0
let g:solarized_termcolors=256
colorscheme solarized
" }}}

" Indent Guides {{{
let g:indent_guides_guide_size=2
" }}}

" Cursor {{{
hi CursorLineNR ctermbg=15 ctermfg=0

" Cursorline in active window only
augroup CursorLine
au!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END
" }}}

" YouCompleteMe {{{
  let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py' 
  let g:ycm_add_preview_to_completeopt=1
  let g:ycm_autoclose_preview_window_after_insertion=1
" }}}

" Lightline {{{
  set laststatus=2
  set noshowmode
 " let g:airline_symbols.linenr = ''

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
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
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
  endfunction

  function! LLReadonly()
    if &filetype == 'help'
      return ''
    elseif &readonly
      return ''
    else
      return '' 
  endfunction

  function! LLFilename()
    return ('' != LLReadonly() ? LLReadonly() . ' ' : '') .
         \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
         \ ('' != LLModified() ? ' ' . LLModified() : '')
  endfunction
" }}}

" Closetag {{{
  autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
  autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag/plugin/closetag.vim
" }}}

" Tagbar {{{
  let g:tagbar_usearrows=1
  nnoremap <leader>t :TagbarToggle<CR> 
" }}}

" NERDTree {{{
    let NERDTreeShowHidden=1
    nnoremap <leader>n :NERDTreeToggle<CR>
" }}}

" etc {{{
  " Autocmds {{{
    augroup vimrcEx
    au!
      " When editing a file, jump to the last known cursor position.
      au BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

      " Set cmake file type properly
      au BufRead,BufNewFile *.cmake,CMakeLists.txt set filetype=cmake
    augroup END
    
      " Set absolute numbers in insert mode or when out of focus
      au InsertEnter,WinLeave,FocusLost * setlocal norelativenumber
      au InsertLeave,WinEnter * setlocal relativenumber

    " Diff original file with edits
    if !exists(":DiffOrig")
      command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    		\ | wincmd p | diffthis
    endif
  " }}}

  " Mappings {{{
    " Normal {{{
      " Quit and save session as current
      nnoremap <leader>qs :mksession! ~/.vim/sessions/current.vim<cr>:qa<cr>
      " Just save session as current
      nnoremap <leader>ss :mksession! ~/.vim/sessions/current.vim<cr>
      " Save session as
      nnoremap <leader>as :mksession! ~/.vim/sessions/
      " Remap window functions to <leader>w
      nnoremap <leader>w <C-w>
      " Resource .vimrc
      nnoremap <leader>rc :source ~/.vimrc<cr>
    " }}}
    " Insert {{{
      " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
      " so that you can undo CTRL-U after inserting a line break.
      inoremap <C-U> <C-G>u<C-U>
      
      " Sublime-style brace indenting code blocks
      inoremap {<cr> {<cr>}<c-o>O
      inoremap [<cr> [<cr>]<c-o>O
      inoremap (<cr> (<cr>)<c-o>O
    " }}}
    " Command {{{
      " Save as root
      cnoremap sudow w !sudo tee % > /dev/null
    " }}}
  " }}}
" }}}
