--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: init.lua
-- Description: Entry point loaded by Neovim on startup
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>

if vim.fn.has("nvim-0.8") == 0 then
	error("Need Neovim 0.8+ in order to use this config")
end

-- Fail fast with a clear message if an external dependency used by the
-- plugins below (telescope, treesitter, ...) is missing from $PATH.
for _, cmd in ipairs({"git", "rg", {"fd", "fdfind"}}) do
	local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
	local candidates = type(cmd) == "string" and {cmd} or cmd
	local found = false

	for _, candidate in ipairs(candidates) do
		if vim.fn.executable(candidate) == 1 then
			name = candidate
			found = true
			break
		end
	end

	if not found then
		error(("`%s` is not installed"):format(name))
	end
end

-- Everything else lives under lua/config and lua/plugins
require("config")
