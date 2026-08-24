--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/lualine.lua
-- Description: Statusline
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
return {{
	"nvim-lualine/lualine.nvim",
	dependencies = {"nvim-tree/nvim-web-devicons"},
	opts = {
		options = {
			theme = "auto", -- match the active colorscheme
			component_separators = {left = "", right = ""},
			section_separators = {left = "", right = ""}
		},
		sections = {
			lualine_a = {"mode"},
			lualine_b = {"branch", "diff", "diagnostics"},
			lualine_c = {"filename"},
			lualine_x = {"encoding", "fileformat", "filetype"},
			lualine_y = {"progress"},
			lualine_z = {"location"}
		},
		inactive_sections = {
			lualine_c = {"filename"},
			lualine_x = {"location"}
		}
	}
}}
