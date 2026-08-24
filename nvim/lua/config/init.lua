--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: config/init.lua
-- Description: Bootstraps lazy.nvim, loads plugins and core config modules
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>

-- Bootstrap lazy.nvim (the plugin manager) if it isn't installed yet
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.opt.termguicolors = true -- enable 24-bit RGB colors

-- Every file under lua/plugins/ is loaded automatically. lua/plugins/custom.lua
-- is an optional, gitignored file for machine-local plugins that isn't part of
-- this repo; it's only added to the spec when present.
local spec = {{
	import = "plugins"
}}

if pcall(require, "plugins.custom") then
	table.insert(spec, {
		import = "plugins.custom"
	})
end

require("lazy").setup({
	root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
	spec = spec,
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
	defaults = {
		lazy = false -- should plugins be lazy-loaded by default?
	},
	install = {
		-- install missing plugins on startup
		missing = true,
		-- colorscheme to fall back to while plugins are being installed
		colorscheme = {"dracula", "habamax"}
	},
	checker = {
		-- automatically check for plugin updates
		enabled = true,
		-- get a notification when new updates are found (off, it's noisy)
		notify = false,
		-- check for updates every day
		frequency = 86400
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		-- get a notification when changes are found (off, it's noisy)
		notify = false
	},
	performance = {
		cache = {
			enabled = true
		}
	},
	state = vim.fn.stdpath("state") .. "/lazy/state.json" -- state info for checker and other things
})

-- config.custom is an optional, gitignored module for machine-local settings
-- that isn't part of this repo, so it's allowed to be missing.
local modules = {"config.filetypes", "config.autocmds", "config.options", "config.keymaps", "config.custom"}

for _, mod in ipairs(modules) do
	local ok, err = pcall(require, mod)
	if not ok and mod ~= "config.custom" then
		error(("Error loading %s...\n\n%s"):format(mod, err))
	end
end
