--
-- ███╗	 ██╗███████╗ ██████╗ ██╗	 ██╗██╗███╗	 ███╗
-- ████╗	██║██╔════╝██╔═══██╗██║	 ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗	██║	 ██║██║	 ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝	██║	 ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝	╚═══╝╚══════╝ ╚═════╝	 ╚═══╝	╚═╝╚═╝		 ╚═╝
--
-- File: plugins/telescope.lua
-- Description: nvim-telescope config
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
return {{
	'nvimdev/dashboard-nvim',
	event = 'VimEnter',
	config = function()
		require('dashboard').setup { }
	end,
	dependencies = { {'nvim-tree/nvim-web-devicons'}}
}}
