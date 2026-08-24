--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/gitsigns.lua
-- Description: Git change markers in the sign column, hunk navigation/staging
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
return {{
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = {text = "┃"},
			change = {text = "┃"},
			delete = {text = "_"},
			topdelete = {text = "‾"},
			changedelete = {text = "~"},
			untracked = {text = "┆"}
		},
		current_line_blame = false, -- toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text_pos = "eol"
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, {buffer = bufnr, desc = desc})
			end

			-- Hunk navigation
			map("n", "]c", gitsigns.next_hunk, "Next git hunk")
			map("n", "[c", gitsigns.prev_hunk, "Previous git hunk")

			-- Hunk actions
			map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
			map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
			map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
			map("n", "<leader>hb", gitsigns.blame_line, "Blame line")
		end
	}
}}
