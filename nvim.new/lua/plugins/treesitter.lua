--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/treesitter.lua
-- Description: Treesitter parsers, used for syntax highlighting
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
return {{
	"nvim-treesitter/nvim-treesitter",
	version = false, -- track the branch HEAD, not release tags
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"go", "python", "dockerfile", "json", "yaml", "markdown", "html", "scss", "css", "vim",
			"java", "javascript"
		},
		highlight = {
			enable = true
		},
		indent = {
			enable = false
		}
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end
}}
