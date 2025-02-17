--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: config/options.lua
-- Description: General Neovim settings and configuration
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
local cmd = vim.cmd

-- Set options (global/buffer/windows-scoped)
local opt = vim.opt

-- Global variables
local g = vim.g
local s = vim.s
local indent = 4

cmd([[
	filetype plugin indent on
]])

opt.backspace = {"eol", "start", "indent"} -- allow backspacing over everything in insert mode
opt.clipboard = "unnamedplus" -- allow neovim to access the system clipboard
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
opt.encoding = "utf-8" -- the encoding
opt.matchpairs = {"(:)", "{:}", "[:]", "<:>"}
opt.syntax = "enable"

-- search
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.smartcase = true -- smart case
opt.wildignore = opt.wildignore + {"*/node_modules/*", "*/.git/*", "*/vendor/*"}
opt.wildmenu = true -- make tab completion for files/buffers act like bash

opt.tabstop=2
opt.shiftwidth=2

opt.cursorline = true -- highlight the current line
opt.laststatus = 2 -- only the last window will always have a status line
opt.lazyredraw = true -- don"t update the display while executing macros
opt.list = true
opt.listchars = {
	space = ".",
	tab = "> ",
	trail = "·",
	extends = "»",
	precedes = "«",
	nbsp = "×"
}

-- Hide cmd line
opt.cmdheight = 0 -- more space in the neovim command line for displaying messages

opt.mouse = "a" -- allow the mouse to be used in neovim
opt.mousemodel = "extend"
opt.number = true -- set numbered lines
opt.scrolloff = 0 -- minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 0 -- minimal number of screen columns to keep to the left and right (horizontal) of the cursor if wrap is `false`
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.splitbelow = true -- open new split below
opt.splitright = true -- open new split to the right
opt.wrap = false -- display a long line

-- backups
opt.backup = false -- create a backup file
opt.swapfile = false -- creates a swapfile
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- autocomplete
opt.completeopt = {"menu", "menuone", "noselect"} -- mostly just for cmp
opt.shortmess = opt.shortmess + {
	c = true
} -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"

-- By the way, -- INSERT -- is unnecessary anymore because the mode information is displayed in the statusline.
opt.showmode = false

-- perfomance
opt.history = 100 -- keep 100 lines of history
opt.redrawtime = 1500
opt.timeoutlen = 250 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.ttimeoutlen = 10
opt.updatetime = 100 -- signify default updatetime 4000ms is not good for async update

-- theme
opt.termguicolors = true -- enable 24-bit RGB colors

-- persistent undo
-- don"t forget to create folder $HOME/.local/share/nvim/undo
local undodir = vim.fn.stdpath("data") .. "/undo"
opt.undofile = true -- enable persistent undo
opt.undodir = undodir
opt.undolevels = 1000
opt.undoreload = 10000

-- fold
opt.foldmethod = "marker"
opt.foldlevel = 99

-- disable builtin plugins
local disabled_built_ins = {
	"2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
	"netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
	"spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
	"synmenu", "optwin", "compiler", "bugreport", "ftplugin"}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

-- colorscheme
cmd.colorscheme("gruvbox")
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
