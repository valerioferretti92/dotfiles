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
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>

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

-- NvimTree
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", {}) -- open/close

-- Tabs
vim.keymap.set("n", "<leader>n", "<cmd>:tabn<cr>", {desc = 'Tab next'})
vim.keymap.set("n", "<leader>p", "<cmd>:tabp<cr>", {desc = 'Tab prev'})
vim.keymap.set("n", "<leader>c", "<cmd>:tabc<cr>", {desc = 'Tab prev'})
