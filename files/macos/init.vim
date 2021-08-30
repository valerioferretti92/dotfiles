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

set background=dark
colorscheme gruvbox
