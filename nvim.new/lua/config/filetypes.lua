--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: config/filetypes.lua
-- Description: Custom filetype detection for languages Neovim doesn't know
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
--
-- Most languages need nothing here at all: Neovim already ships filetype
-- detection for things like Go, JSON, YAML, SQL, CSS, HTML, Java, JS/TS, and
-- Bash (see $VIMRUNTIME/lua/vim/filetype.lua). Once a buffer has the right
-- `filetype`, treesitter (plugins/treesitter.lua) and the language server
-- (plugins/lsp.lua) attach to it automatically by matching on that filetype.
--
-- This file only exists for the two languages that need a nudge:
--
--  * Helm chart templates are just YAML/text files with Go template syntax
--    ({{ .Values.foo }}) sprinkled in. Neovim has no way to know a given
--    `templates/deployment.yaml` is a Helm template rather than plain YAML,
--    so we detect it from the file's path instead of its extension.
--  * Nunjucks (.njk) templates use ~the same {{ }} / {% %} syntax as Jinja2,
--    and there's no dedicated Nunjucks treesitter parser, so we just tell
--    Neovim to treat .njk files as Jinja, which is close enough for
--    highlighting.
--
-- `vim.filetype.add` is the general tool for this: `extension`/`filename`
-- keys do plain string matching, `pattern` keys are Lua patterns matched
-- against the full path, and any of them can map to a function instead of a
-- string if the filetype depends on more than just the path (as with Helm
-- below, where we also check for a sibling Chart.yaml).
-- See `:help vim.filetype.add` for the full API.

-- A file belongs to a Helm chart if it sits under a `templates/` directory
-- that itself sits next to a `Chart.yaml` (i.e. `<chart>/templates/*`).
local function is_helm_chart_template(templates_dir)
	local chart_dir = vim.fn.fnamemodify(templates_dir, ":h")
	return vim.fn.filereadable(chart_dir .. "/Chart.yaml") == 1
end

vim.filetype.add({
	pattern = {
		-- templates/*.yaml, templates/*.tpl, templates/NOTES.txt, ...
		[".*/templates/.*%.ya?ml"] = function(path)
			if is_helm_chart_template(vim.fn.fnamemodify(path, ":h")) then
				return "helm"
			end
		end,
		[".*/templates/.*%.tpl"] = function(path)
			if is_helm_chart_template(vim.fn.fnamemodify(path, ":h")) then
				return "helm"
			end
		end,
		-- A chart's values.yaml gets the compound filetype "yaml.helm-values":
		-- the part before the dot ("yaml") is what yamlls and treesitter match
		-- on, so it's still highlighted/completed as plain YAML, while the
		-- full string is what helm_ls matches on for values-aware completion.
		[".*/values%.ya?ml"] = function(path)
			local chart_dir = vim.fn.fnamemodify(path, ":h")
			if vim.fn.filereadable(chart_dir .. "/Chart.yaml") == 1 then
				return "yaml.helm-values"
			end
		end
	},
	extension = {
		njk = "jinja"
	}
})
