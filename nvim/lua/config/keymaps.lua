--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: config/keymaps.lua
-- Description: Key mapping configs
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>

-- Panes
vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", {})
vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", {})
vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", {})

-- Close all windows and exit from Neovim with <leader> and q
vim.keymap.set("n", "<leader>q", ":qa!<CR>", {})

-- Fast saving with <leader> and s
vim.keymap.set("n", "<leader>s", ":w<CR>", {})

-- Reload config
vim.keymap.set("n", "<leader>r", ":so %<CR>", {})

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader><cr>', '<cmd>:Telescope find_files<cr>', {desc = 'Tab prev'})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Tabs
vim.keymap.set("n", "<leader>n", "<cmd>:tabn<cr>", {desc = 'Tab next'})
vim.keymap.set("n", "<leader>p", "<cmd>:tabp<cr>", {desc = 'Tab prev'})
vim.keymap.set("n", "<leader>c", "<cmd>:tabc<cr>", {desc = 'Quit tab'})

-- NvimTree
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", {})
vim.keymap.set('n', 'C-x', api.node.open.horizontal, opts('Open: Horizontal Split'))
vim.keymap.set('n', 'C-y', api.node.open.vertical, opts('Open: Vertical Split'))
vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
vim.keymap.set('n', 'a', api.fs.create, opts('Create File Or Directory'))
vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
vim.keymap.set('n', 'y', api.fs.copy.node, opts('Copy'))
