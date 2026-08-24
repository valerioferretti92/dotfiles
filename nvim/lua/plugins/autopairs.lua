--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/autopairs.lua
-- Description: Auto-close brackets/quotes, and play nice with nvim-cmp
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
return {{
	"windwp/nvim-autopairs",
	opts = {
		check_ts = true, -- use treesitter to decide whether to add a pair
		ts_config = {
			lua = {"string"}, -- don't add a pair inside these treesitter nodes
			javascript = {"template_string"},
			java = false -- don't use treesitter checks for java at all
		},
		enable_check_bracket_line = false, -- add pairs even if the line already has a closing one
		ignored_next_char = "[%w%.]", -- don't add a pair if next char is alphanumeric or `.`
		fast_wrap = {},
		disable_filetype = {"TelescopePrompt", "vim"}
	},
	config = function(_, opts)
		require("nvim-autopairs").setup(opts)

		-- make nvim-cmp add the matching closing pair when a completion is confirmed
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end
}}
