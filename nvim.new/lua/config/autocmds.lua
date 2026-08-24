--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: config/autocmds.lua
-- Description: Autocommand functions
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- All autocommands below live in this single group. `clear = true` wipes any
-- previous autocommands in the group, so reloading this file (e.g. via the
-- <leader>r keymap) doesn't register the same autocommand twice.
local group = augroup("valerio_autocmds", {
	clear = true
})

-- Briefly flash the yanked text, so it's easy to see what was just copied
autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 1000
		})
	end
})

-- Strip trailing whitespace on every save
autocmd("BufWritePre", {
	group = group,
	pattern = "*",
	command = [[%s/\s\+$//e]]
})

-- Format the buffer on save using whatever LSP client is attached
-- https://neovim.io/doc/user/lsp.html#vim.lsp.buf.format()
autocmd("BufWritePre", {
	group = group,
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({
			timeout_ms = 2000
		})
	end
})

-- Don't let filetype plugins auto-insert comment leaders on `o`/`O`/<CR>
autocmd("BufEnter", {
	group = group,
	pattern = "*",
	command = "set formatoptions-=c formatoptions-=r formatoptions-=o"
})

-- Indent with spaces by default, real tabs for filetypes that expect them
autocmd("FileType", {
	group = group,
	pattern = "*",
	command = "setlocal expandtab"
})
autocmd("FileType", {
	group = group,
	pattern = {"go", "sh", "lua"},
	command = "setlocal noexpandtab"
})

-- Show a ruler at 80 columns
autocmd("FileType", {
	group = group,
	pattern = "*",
	command = "setlocal colorcolumn=80"
})

-- Prose-like filetypes: wrap at window width and turn spellcheck on
autocmd("FileType", {
	group = group,
	pattern = {"gitcommit", "markdown", "text"},
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end
})
