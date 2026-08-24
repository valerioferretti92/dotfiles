--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/telescope.lua
-- Description: Fuzzy finder for files, grep, buffers, help, ...
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
--
-- The <leader>f* keymaps that call these pickers live in config/keymaps.lua.
return {{
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make" -- native sorter, faster than the default Lua one
		}
	},
	config = function()
		require("telescope").setup()
		require("telescope").load_extension("fzf")
	end
}}
