" Plugins {{{
set nocompatible
call plug#begin('~/.nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'altercation/vim-colors-solarized'
Plug 'skammer/vim-css-color'
Plug 'vim-airline/vim-airline'
Plug 'easymotion/vim-easymotion'


Plug 'christoomey/vim-tmux-navigator'
Plug 'rking/ag.vim'
Plug 'rust-lang/rust.vim'
"
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neomake/neomake'

  " Remember to run pip install jedi for Python 2/3
  Plug 'deoplete-plugins/deoplete-jedi'
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

call plug#end()

" }}}
" Leader {{{

let mapleader=';'
let maplocalleader=';'

" }}}
set autochdir
" Plugin settings {{{

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

nnoremap <leader><leader> :NERDTreeToggle<esc>

let NERDTreeIgnore = ['\.pyc$']

let g:haddock_browser="open"

nmap <leader>c gcc
nmap <leader>cl gc
xmap <leader>cl gc
omap <leader>cl gc
" }}}
" General options {{{
set number
set ruler
set autoindent
set smartindent
set encoding=utf-8
set backspace=indent,eol,start
set modelines=0
set laststatus=2
set showcmd
if v:version > 703
  set undofile
  set undoreload=10000
  set undodir=~/.nvim/tmp/undo/     " undo files
endif
set splitright
set splitbelow
set autoread " auto reload file on change

set scrolloff=8 "keep 8 lines below/above cursor
" }}}
" Colorscheme {{{
let g:solarized_termcolors=256
let g:solarized_underline=0
let g:solarized_termtrans="1"
set background=dark
colorscheme solarized
highlight LineNr ctermfg=grey
" }}}
" Wrapping {{{
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set listchars=tab:\ \ ,trail:·

function! s:setupWrapping()
  setlocal wrap
  setlocal wrapmargin=2
  setlocal textwidth=80
  if v:version > 703
    setlocal colorcolumn=+1
  endif
endfunction

" }}}
" Searching and movement {{{
" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" Easier to type, and I never use the default behavior. <3 sjl
noremap H ^
noremap L g_
" }}}
" Backups and undo {{{
set backupdir=~/.nvim/tmp/backup/ " backups
set directory=~/.nvim/tmp/swap/   " swap files
set backup                       " enable backups
set backupskip=/tmp/*,/private/tmp/*"
" }}}
" Folding {{{
set foldlevelstart=0

" Space to toggle folds.
nnoremap <leader><Space> za
vnoremap <leader><Space> za

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . ' ' . repeat(" ",fillcharcount) . ' ' . foldedlinecount . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" I hate K {{{
nnoremap K <nop>
" }}}
" Filetype specific {{{
" Markdown {{{

augroup ft_markdown
  au!

  au BufNewFile,BufRead *.m*down setlocal filetype=markdown
  au BufNewFile,BufRead *.md setlocal filetype=markdown
  au Filetype markdown call s:setupWrapping()

  " Use <localleader>1/2/3 to add headings.
  au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=
  au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-
  au Filetype markdown nnoremap <buffer> <localleader>3 I### <ESC>
augroup END
" }}}
" C# {{{
augroup c_sharp
  au!
  au Filetype cs setlocal ts=4 sw=4 sts=4
augroup END
" }}}
" C {{{
augroup c_lang
  au!
  au Filetype cpp setlocal ts=2 sw=2 sts=2
  au Filetype c setlocal ts=4 sw=4 sts=4
augroup END
" }}}
" Haskell {{{
augroup haskell
  au!
  au Filetype haskell setlocal ts=4 sw=4 sts=4
  au FileType haskell compiler ghc
augroup END
" }}}
" Java {{{
augroup java
  au!
  au Filetype java setlocal ts=4 sw=4 sts=4

augroup END
" }}}
" Latex {{{
augroup ft_latex
  au!

  au Filetype tex call s:setupWrapping()
  au Filetype tex setlocal spell

augroup END
" }}}
" Python {{{
augroup ft_python
  au!

  au FileType python setlocal ts=4 sw=4 sts=4
  au FileType python setlocal wrap wrapmargin=2 textwidth=80 colorcolumn=+1

augroup END
" }}}
" Ruby {{{
augroup ft_ruby
  au!

  au FileType ruby call s:setupWrapping()

augroup END
" }}}
" Nginx {{{
augroup ft_nginx
  au!

  au FileType nginx setlocal ts=4 sts=4 sw=4

augroup END
" }}}
" }}}
" Mappings {{{
nnoremap <silent> <C-l> :noh<CR><C-L>
" edit and source vimrc easily
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<cr>

" rewrite file with sudo
cmap w!! w !sudo tee % >/dev/null
nnoremap _md :set ft=markdown<CR>

" }}}
" Tab completion for commands {{{
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*
" }}}
" some autocommands {{{
augroup unrelated_au
  au!

  " function to remove trailing whitespace without moving to it
  function! s:removeTrailingWhitespace()
    normal! ma
    :%s/\s\+$//e
    normal! `a
  endfunction

  " Remove trailing whitespace
  autocmd BufWritePre * :call s:removeTrailingWhitespace()

  " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

  " json == javascript
  au BufNewFile,BufRead *.json set ft=javascript

  au BufRead {.vimrc,vimrc} set foldmethod=marker

  au BufRead /etc/nginx/* set ft=nginx

augroup END
"}}}
" Relative number toggle {{{
function! ToggleNumberRel()
  if &relativenumber
    setlocal number
  else
    setlocal relativenumber
  endif
endfunction
" Quickly toggle between relativenumber and number
noremap <leader>rr :call ToggleNumberRel()<CR>
" }}}
" Inline mathematics {{{
function! PipeToBc()
  let saved_unnamed_register = @@

  silent execute 'r !echo ' . shellescape(getline('.')) . ' | bc'
  normal! dw
  execute "normal! kA = \<ESC>p"
  normal! jdd

  let @@ = saved_unnamed_register
endfunction
nnoremap <leader>bc :call PipeToBc()<CR>
" }}}
" CtrlP Options {{{
if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -f -l --nocolor --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'
endif

" }}}

" for some reason vim searches for something
:noh
" I hate arrow keys
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>


" " I have a bad habit of long lines
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

" Buffer switching
nnoremap <leader>n :bn<cr>
nnoremap <leader>p :bp<cr>

" Syntastic settings
let g:syntastic_python_checkers=['flake8']
"let g:syntastic_python_python_exec = '/usr/bin/python'
let g:syntastic_r_lint_styles = 'list(spacing.indentation.notabs, spacing.indentation.evenindent)'

let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = '--std=c++11 -Wall'
let g:syntastic_cpp_checkers=['clang_check', 'clang_tidy', 'gcc']
if &ft != 'php'
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list=1
  let g:syntastic_quiet_messages = { "type": "style" }
endif
let g:syntastic_mode_map = { 'passive_filetypes': ["java", "cpp", "php"] }

" Lines added by the Vim-R-plugin command :RpluginConfig (2014-Sep-26 11:39):
filetype plugin on
inoremap <_> <_>
" Use Ctrl+Space to do omnicompletion:
if has("gui_running")
    inoremap <C-Space> <C-x><C-o>
else
    inoremap <Nul> <C-x><C-o>
endif
" Press the space bar to send lines (in Normal mode) and selections to R:
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine

" Force Vim to use 256 colors if running in a capable terminal emulator:
if &term =~ "xterm" || &term =~ "256" || $DISPLAY != "" || $HAS_256_COLORS == "yes"
    set t_Co=256
endif

" Command to instantly format JSON
com! FormatJSON %!python -m json.tool

" Ag options
nnoremap <leader>a  :Ag<Space>

" Ag options
nnoremap <leader>a  :Ag<Space>

" Python for neovim
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3.7'

" Remapping navigation
:tnoremap <C-h> <C-\><C-n><C-w>h
:tnoremap <C-j> <C-\><C-n><C-w>j
:tnoremap <C-k> <C-\><C-n><C-w>k
:tnoremap <C-l> <C-\><C-n><C-w>l

:nnoremap <C-h> <C-w>h
:nnoremap <C-j> <C-w>j
:nnoremap <C-k> <C-w>k
:nnoremap <C-l> <C-w>l

vnoremap // y/<C-R>"<CR>

let g:neomake_python_flake8_maker = {
    \ 'args': ['--ignore=W503', '--format=default'],
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#',
    \ }
let g:neomake_python_enabled_makers = ['flake8']
autocmd! BufWritePost * Neomake

" Rust language serve
autocmd BufReadPost *.rs setlocal filetype=rust

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

" Maps K to hover, gd to goto definition, F2 to rename
nnoremap <silent> K :call LanguageClient_textDocument_hover()
nnoremap <silent> gd :call LanguageClient_textDocument_definition()
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()
