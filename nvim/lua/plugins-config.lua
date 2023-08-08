-- Gruvbox config
require("gruvbox").setup({
	undercurl = true,
	underline = true,
	bold = true,
	strikethrough = true,
	invert_selection = false,
	invert_signs = false,
	invert_tabline = false,
	invert_intend_guides = false,
	inverse = true,
	contrast = "hard",
	overrides = {},
})

require('hardline').setup {
  bufferline = false,  -- disable bufferline
  bufferline_settings = {
    exclude_terminal = false,  -- don't show terminal buffers in bufferline
    show_index = false,        -- show buffer indexes (not the actual buffer numbers) in bufferline
  },
  theme = 'gruvbox',   -- change theme
  sections = {         -- define sections
    {class = 'mode', item = require('hardline.parts.mode').get_item},
    {class = 'bufferline', item = require('hardline.parts.filename').get_item},
    '%<',
    {class = 'bufferline', item = '%='},
    {class = 'bufferline', item = require('hardline.parts.filetype').get_item, hide = 60},
    {class = 'bufferline', item = require('hardline.parts.line').get_item},
  },
}

-- Telescope config
require("telescope").setup({
	picker = {
		hidden = false,
	},
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--no-ignore",
			"--smart-case",
			"--hidden",
		},
		prompt_prefix = "   ",
		selection_caret = "  ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = {"node_modules", ".git/", "dist/", "node_modules"},
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = { "absolute" },
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		use_less = true,
		set_env = { ["COLORTERM"] = "truecolor" },
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
	},
	extensions = {
			fzf = {
				fuzzy = false,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
})

-- Treesitter config
require("nvim-treesitter.configs").setup {
  ensure_installed = { "c", "lua", "vim", "help", "query" },
  sync_install = false,
  auto_install = true,
  ignore_install = { "help" },
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
}
