--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/lsp.lua
-- Description: Language servers (via mason), autocompletion (via nvim-cmp)
-- Author: Valerio Ferretti <valerio.ferretti92@gmail.com>
--
-- Formatting on save is handled generically in config/autocmds.lua via
-- vim.lsp.buf.format(), so it isn't repeated here.

-- Diagnostics: gutter signs + a single-line virtual text summary
vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 4,
		source = "if_many"
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = ""
		}
	},
	float = {
		border = "rounded",
		source = true
	}
})

-- Keymaps below are buffer-local and only set once a language server has
-- actually attached to that buffer.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("valerio_lsp_attach", {clear = true}),
	callback = function(event)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, {buffer = event.buf, desc = desc})
		end

		map("n", "gd", vim.lsp.buf.definition, "Goto definition")
		map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
		map("n", "gr", vim.lsp.buf.references, "Goto references")
		map("n", "gI", vim.lsp.buf.implementation, "Goto implementation")
		map("n", "K", vim.lsp.buf.hover, "Hover documentation")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>e", vim.diagnostic.open_float, "Show line diagnostics")
		map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
		map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
	end
})

return {{
	-- Portable package manager: installs LSP servers, DAP servers,
	-- linters and formatters without needing them on $PATH already.
	"williamboman/mason.nvim",
	cmd = {"Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog"},
	opts = {
		ui = {
			icons = {
				package_pending = " ",
				package_installed = "󰄳 ",
				package_uninstalled = " 󰚌"
			}
		}
	}
}, {
	"neovim/nvim-lspconfig",
	event = {"BufReadPre", "BufNewFile"},
	dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/nvim-cmp"},
	opts = {
		-- Keys are lspconfig server names, {} means "use its defaults". To add
		-- a language: find its server name under lua/lsp/*.lua in the
		-- nvim-lspconfig repo (or `:help lspconfig-all`), add it here with {},
		-- and mason will install the underlying binary the next time you open
		-- a matching file. Only add per-server settings (like gopls below) if
		-- the defaults aren't good enough.
		servers = {
			-- bash
			bashls = {},
			-- go: gopls reads its options from the LSP `settings` payload,
			-- namespaced under its own name (`settings.gopls`), not from the
			-- top level of the client config
			gopls = {
				settings = {
					gopls = {
						analyses = {
							unusedparams = true
						},
						staticcheck = true,
						gofumpt = true
					}
				}
			},
			-- json / yaml
			jsonls = {},
			yamlls = {},
			-- sql: only attaches inside a project with a `.sqllsrc.json` file,
			-- see https://github.com/joe-re/sql-language-server
			sqlls = {},
			-- helm: only attaches inside a chart (a directory with Chart.yaml),
			-- see config/filetypes.lua for how .yaml files under templates/ are
			-- recognized as Helm rather than plain YAML
			helm_ls = {},
			-- javascript / typescript
			ts_ls = {},
			eslint = {},
			biome = {},
			-- java
			jdtls = {},
			-- css / html
			cssls = {},
			html = {},
			-- misc
			dockerls = {},
			ruff = {}, -- python
			vimls = {}
		}
	},
	config = function(_, opts)
		-- `vim.lsp.config()` is Neovim's own registry of per-server settings
		-- (native since 0.11); nvim-lspconfig just ships the bundled defaults
		-- it reads from. The "*" server name below sets defaults merged into
		-- *every* server's config, which is how the cmp_nvim_lsp capabilities
		-- (autocompletion-related capabilities the server needs to know
		-- about) reach every language server without repeating them per
		-- server.
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
		vim.lsp.config("*", {
			capabilities = capabilities
		})

		-- Per-server overrides (e.g. gopls below) are merged on top of both
		-- the "*" defaults above and nvim-lspconfig's own defaults for that
		-- server.
		for server, server_opts in pairs(opts.servers) do
			if next(server_opts) then
				vim.lsp.config(server, server_opts)
			end
		end

		-- Installs any server above that mason doesn't have yet, then enables
		-- (`vim.lsp.enable()`) every server mason has installed, using
		-- whichever config was registered for it above.
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(opts.servers)
		})
	end
}, {
	-- Autocompletion, only needed once insert mode is entered
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {{
		"L3MON4D3/LuaSnip", -- snippet engine
		dependencies = "rafamadriz/friendly-snippets", -- the actual vscode-style snippets
		opts = {
			history = true, -- keep snippet placeholders jumpable after leaving insert mode
			updateevents = "TextChanged,TextChangedI"
		},
		config = function(_, opts)
			require("luasnip").setup(opts)
			require("luasnip.loaders.from_vscode").lazy_load()
		end
	}, "saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
					"hrsh7th/cmp-path"},
	opts = function()
		local cmp = require("cmp")

		local function border(hl_name)
			return {{"╭", hl_name}, {"─", hl_name}, {"╮", hl_name}, {"│", hl_name}, {"╯", hl_name}, {"─", hl_name},
					{"╰", hl_name}, {"│", hl_name}}
		end

		return {
			completion = {
				completeopt = "menu,menuone"
			},
			window = {
				completion = {
					winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel"
				},
				documentation = {
					border = border("CmpDocBorder"),
					winhighlight = "Normal:CmpDoc"
				}
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end
			},
			mapping = {
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.close(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Insert,
					select = true
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif require("luasnip").expand_or_jumpable() then
						vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
							"")
					else
						fallback()
					end
				end, {"i", "s"}),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif require("luasnip").jumpable(-1) then
						vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
					else
						fallback()
					end
				end, {"i", "s"})
			},
			sources = {{
				name = "nvim_lsp"
			}, {
				name = "luasnip"
			}, {
				name = "buffer",
				option = {
					-- avoid running on huge buffers
					get_bufnrs = function()
						local buf = vim.api.nvim_get_current_buf()
						if vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf)) > 1024 * 1024 then
							return {}
						end
						return {buf}
					end
				}
			}, {
				name = "nvim_lua"
			}, {
				name = "path"
			}}
		}
	end,
	config = function(_, opts)
		require("cmp").setup(opts)
	end
}}
