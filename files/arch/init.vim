" Commands
set relativenumber
syntax on

call plug#begin('~/.local/share/nvim/plugged')

" Themes
Plug 'gruvbox-community/gruvbox'
" Go lang
Plug 'fatih/vim-go'
" Powerline
Plug 'powerline/powerline'
" Nerd tree
Plug 'preservim/nerdtree'
" Java syntax highlighting
Plug 'uiiaoo/java-syntax.vim'

call plug#end()

" Nertree
nnoremap <F1> :NERDTreeToggle<CR>

" Cursor and cursorline
set guicursor=i:blinkon1 " enable vertical cursor when in insert mode
set cursorline

" Colorscheme
if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also https://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif
set t_8f=^[[38;2;%lu;%lu;%lum        " set foreground color
set t_8b=^[[48;2;%lu;%lu;%lum        " set background color
set t_Co=256                         " Enable 256 colors
if empty($STY)
    set termguicolors                " Enable GUI colors for the terminal to get truecolor
    				     " NOT WORKING IN SCREEN, the if prevents this option 
				     " from being set if running in screen.
				     " truecolor on ---> not working in screen
endif
set background=dark
colorscheme gruvbox

" Tab and indentation
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
