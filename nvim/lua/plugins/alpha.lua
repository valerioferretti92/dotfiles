--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/alpha.lua
-- Description: Start screen shown when Neovim opens with no file argument
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
return {{
	"goolord/alpha-nvim",
	dependencies = {"nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim"},
	config = function()
		-- "theta" theme: recent files + quick actions
		require("alpha").setup(require("alpha.themes.theta").config)
	end
}}
