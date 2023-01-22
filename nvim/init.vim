" Commands
set clipboard+=unnamedplus
set relativenumber
set nu rnu
syntax on

call plug#begin('~/.local/share/nvim/plugged')

" Themes
Plug 'gruvbox-community/gruvbox'
" Go lang
Plug 'fatih/vim-go'
" Java syntax highlighting
Plug 'uiiaoo/java-syntax.vim'
" Lightline
Plug 'itchyny/lightline.vim'
" React
Plug 'mxw/vim-jsx'
" Javascript
Plug 'pangloss/vim-javascript'

call plug#end()

" Cursor and cursorline
set guicursor=i:blinkon1 " enable vertical cursor when in insert mode
set cursorline

" Colors
" Disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" see also https://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
    set t_ut=
endif

" Set forground color
set t_8f=^[[38;2;%lu;%lu;%lum
" Set background color
set t_8b=^[[48;2;%lu;%lu;%lum
" Enable 256 colors
set t_Co=256
    
" Enable GUI colors for the terminal to get truecolor
" NOT WORKING IN SCREEN, the if prevents this option 
" from being set if running in screen.
" truecolor on ---> not working in screen
if empty($STY)
    set termguicolors
endif

" Color scheme
set background=dark
colorscheme gruvbox

" Tab and indentation
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4

" Mouse
set mousemodel=extend
