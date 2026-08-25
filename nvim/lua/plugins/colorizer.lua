--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/colorizer.lua
-- Description: Highlights color codes (#fff, rgb(...), ...) with their color
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
return {{
	"NvChad/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup()
		-- attach to the buffer open at startup too, not just future ones
		vim.defer_fn(function()
			require("colorizer").attach_to_buffer(0)
		end, 0)
	end
}}
