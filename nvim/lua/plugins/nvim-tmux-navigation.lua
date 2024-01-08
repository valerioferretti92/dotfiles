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
	'alexghergh/nvim-tmux-navigation',
	config = function()
		require('nvim-tmux-navigation').setup {
			disable_when_zoomed = true
		}
	end
}}
