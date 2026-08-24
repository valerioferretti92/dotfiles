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
--
-- Treesitter is what actually colors the code (LSP is only for completion/
-- diagnostics/etc, see plugins/lsp.lua). Each entry in `ensure_installed` is
-- a *parser* name, which nvim-treesitter auto-attaches to any buffer whose
-- `filetype` matches that name (see config/filetypes.lua for the couple of
-- filetypes, like helm/jinja, that Neovim doesn't detect on its own).
--
-- To add a new language: find its parser name by running
-- `:lua print(vim.inspect(require("nvim-treesitter.parsers").get_parser_configs()))`
-- (or browse lua/nvim-treesitter/parsers.lua in the plugin's repo), add it
-- below, then run `:TSUpdate` (or just restart Neovim, ensure_installed is
-- applied automatically).
return {{
	"nvim-treesitter/nvim-treesitter",
	version = false, -- track the branch HEAD, not release tags
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			-- general / config formats
			"bash", "json", "yaml", "sql", "dockerfile", "markdown", "vim",
			-- web
			"html", "css", "scss", "javascript", "typescript",
			-- templating: helm chart templates, jinja/nunjucks templates
			"helm", "jinja",
			-- other languages in use
			"go", "python", "java"
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
