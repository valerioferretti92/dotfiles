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
		-- Server names as known by mason-lspconfig; {} means "use defaults"
		servers = {
			jsonls = {},
			dockerls = {},
			bashls = {},
			gopls = {
				analyses = {
					unusedparams = true
				},
				staticcheck = true,
				gofumpt = true
			},
			ts_ls = {},
			eslint = {},
			ruff = {},
			vimls = {},
			yamlls = {},
			jdtls = {},
			biome = {}
		}
	},
	config = function(_, opts)
		local servers = opts.servers
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		local function setup(server)
			local server_opts = vim.tbl_deep_extend("force", {
				capabilities = vim.deepcopy(capabilities)
			}, servers[server] or {})
			require("lspconfig")[server].setup(server_opts)
		end

		-- Servers already installed via mason get set up immediately; the rest
		-- are queued for mason to install, then mason-lspconfig sets them up.
		local mlsp = require("mason-lspconfig")
		local available = mlsp.get_available_servers()
		local ensure_installed = {}

		for server in pairs(servers) do
			if vim.tbl_contains(available, server) then
				ensure_installed[#ensure_installed + 1] = server
			else
				setup(server)
			end
		end

		mlsp.setup({
			ensure_installed = ensure_installed,
			automatic_installation = true
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
