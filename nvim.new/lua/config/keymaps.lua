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
--
-- Keymaps that only make sense once a specific plugin is active (LSP,
-- gitsigns, ...) live next to that plugin's setup instead of here, so this
-- file only holds general-purpose, always-available mappings.

-- Move between tmux panes and Neovim splits with the same keys
vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", {})
vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", {})
vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", {})

-- Close all windows and quit Neovim, discarding unsaved changes
vim.keymap.set("n", "<leader>q", ":qa!<CR>", {desc = "Quit all"})

-- Fast saving
vim.keymap.set("n", "<leader>s", ":w<CR>", {desc = "Save file"})

-- Reload this config without restarting Neovim
vim.keymap.set("n", "<leader>r", ":so %<CR>", {desc = "Reload config"})

-- Telescope: fuzzy finders
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><CR>", builtin.find_files, {desc = "Find files"})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {desc = "Find files"})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {desc = "Live grep"})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {desc = "List buffers"})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {desc = "Search help"})

-- Tabs
vim.keymap.set("n", "<leader>n", "<cmd>tabn<cr>", {desc = "Next tab"})
vim.keymap.set("n", "<leader>p", "<cmd>tabp<cr>", {desc = "Previous tab"})
vim.keymap.set("n", "<leader>c", "<cmd>tabc<cr>", {desc = "Close tab"})
