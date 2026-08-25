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
			"bash", "json", "yaml", "sql", "dockerfile", "markdown", "markdown_inline", "vim",
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

		-- Compatibility fix for Neovim 0.11+ / 0.12+:
		-- In Neovim 0.11+, Neovim core updated how captures are passed to custom
		-- query directive handlers from `table<integer, TSNode>` to `table<integer, TSNode[]>`.
		-- Legacy nvim-treesitter (master branch) registers directives like
		-- `#set-lang-from-info-string!` (used for markdown fenced code blocks) and
		-- passes `match[id]` directly to `vim.treesitter.get_node_text()`.
		-- Since `match[id]` is now `{ <TSNode> }` rather than `<TSNode>`, calling
		-- `node:range()` internally would crash with:
		--   "attempt to call method 'range' (a nil value)"
		-- We override these directives below with `{ force = true }` to safely unpack
		-- the node if it's wrapped in a table before extracting its text.
		local query = require("vim.treesitter.query")
		local function get_node(match, id)
			local node = match[id]
			return type(node) == "table" and node[1] or node
		end

		query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
			local node = get_node(match, pred[2])
			if not node then return end
			local alias = vim.treesitter.get_node_text(node, bufnr):lower()
			local lang = vim.filetype.match({ filename = "a." .. alias }) or alias
			metadata["injection.language"] = lang
		end, { force = true })

		query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
			local node = get_node(match, pred[2])
			if not node then return end
			local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
			local parts = vim.split(type_attr_value, "/", {})
			metadata["injection.language"] = parts[#parts]
		end, { force = true })

		query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
			local id = pred[2]
			local node = get_node(match, id)
			if not node then return end
			local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
			if not metadata[id] then
				metadata[id] = {}
			end
			metadata[id].text = string.lower(text)
		end, { force = true })
	end
}}
