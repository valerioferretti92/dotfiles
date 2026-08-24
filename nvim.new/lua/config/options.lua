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
local opt = vim.opt -- options (global/buffer/window-scoped)
local g = vim.g -- global variables

local indent = 2 -- default width used for tabstop/shiftwidth below

cmd([[filetype plugin indent on]])

opt.backspace = {"eol", "start", "indent"} -- allow backspacing over everything in insert mode
opt.clipboard = "unnamedplus" -- allow neovim to access the system clipboard
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.encoding = "utf-8" -- the encoding used internally
opt.matchpairs = {"(:)", "{:}", "[:]", "<:>"}
opt.syntax = "enable"

-- search
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.smartcase = true -- ...unless the pattern contains an uppercase letter
opt.wildignore:append({"*/node_modules/*", "*/.git/*", "*/vendor/*"})
opt.wildmenu = true -- make tab completion for files/buffers act like bash

opt.tabstop = indent
opt.shiftwidth = indent

opt.cursorline = true -- highlight the current line
opt.laststatus = 2 -- only the last window will always have a status line
opt.lazyredraw = true -- don't update the display while executing macros
opt.list = true -- show whitespace characters, see listchars below
opt.listchars = {
	space = ".",
	tab = "> ",
	trail = "·",
	extends = "»",
	precedes = "«",
	nbsp = "×"
}

opt.cmdheight = 0 -- hide the command line when it's not in use, more room for the buffer
opt.mouse = "a" -- allow the mouse to be used in all modes
opt.mousemodel = "extend"
opt.number = true -- show line numbers
opt.scrolloff = 0 -- minimal number of screen lines to keep above/below the cursor
opt.sidescrolloff = 0 -- minimal number of screen columns to keep left/right of the cursor (when wrap=false)
opt.signcolumn = "yes" -- always show the sign column, otherwise it shifts the text every time it appears
opt.splitbelow = true -- open new horizontal splits below the current window
opt.splitright = true -- open new vertical splits to the right of the current window
opt.wrap = false -- don't soft-wrap long lines

-- backups: rely on persistent undo (below) instead of swap/backup files
opt.backup = false
opt.swapfile = false
opt.writebackup = false

-- autocomplete (mostly for nvim-cmp)
opt.completeopt = {"menu", "menuone", "noselect"}
opt.shortmess:append("c") -- hide completion messages, e.g. "match 1 of 2", "Pattern not found"
opt.showmode = false -- redundant: the mode is already shown in the statusline

-- performance
opt.history = 100 -- keep 100 lines of command-line history
opt.redrawtime = 1500
opt.timeoutlen = 250 -- time to wait for a mapped key sequence to complete (ms)
opt.ttimeoutlen = 10
opt.updatetime = 100 -- affects CursorHold and gitsigns/diagnostics responsiveness

opt.termguicolors = true -- enable 24-bit RGB colors

-- persistent undo, kept across sessions
local undodir = vim.fn.stdpath("data") .. "/undo"
opt.undofile = true
opt.undodir = undodir
opt.undolevels = 1000
opt.undoreload = 10000

-- folding: fold on markers ({{{ }}}) rather than indent/syntax, but start fully open
opt.foldmethod = "marker"
opt.foldlevel = 99

-- Disable builtin plugins/features we don't use, to keep startup lean
local disabled_built_ins = {
	"2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
	"netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
	"spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
	"synmenu", "optwin", "compiler", "bugreport", "ftplugin"
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

-- colorscheme (plugin is set up in lua/plugins/colorscheme.lua)
cmd.colorscheme("dracula")
cmd("highlight Normal guibg=NONE ctermbg=NONE") -- transparent background, uses the terminal's own
