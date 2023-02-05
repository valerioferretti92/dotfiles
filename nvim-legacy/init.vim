" Commands
set relativenumber
set nu rnu
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
" Light line
Plug 'itchyny/lightline.vim'

call plug#end()

" Nertree
nnoremap <F1> :NERDTreeToggle<CR>

" Cursor and cursorline
set cursorline

set background=dark
colorscheme gruvbox

" Tab and indentation
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
