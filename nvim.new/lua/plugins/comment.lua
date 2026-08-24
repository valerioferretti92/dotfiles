--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/comment.lua
-- Description: Toggle line/block comments (treesitter-aware)
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
--
-- Remaps the default gcc/gc keys to the m-prefixed ones below; everything
-- else is left at Comment.nvim's defaults.
return {{
	"numToStr/Comment.nvim",
	opts = {
		toggler = {
			line = "mm", -- toggle comment on the current line
			block = "mbm" -- toggle block comment on the current line
		},
		opleader = {
			line = "m", -- e.g. `mip` comments a paragraph (operator + motion)
			block = "mb"
		},
		extra = {
			above = "mO", -- add comment on the line above
			below = "mo", -- add comment on the line below
			eol = "mA" -- add comment at the end of the line
		}
	}
}}
