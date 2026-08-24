# My Neovim config

This is a personal Neovim config, rebuilt from a copy-pasted starting point
into something intentionally minimal: **a fast text editor, not an IDE**.
No file tree, no debugger, no dashboard full of widgets — just fast
navigation, syntax highlighting, and just enough language intelligence
(diagnostics/completion/go-to-definition) for the languages actually used
day to day.

This file explains how the pieces fit together and *why* things are the way
they are, so you can extend it confidently later without re-deriving
everything from scratch. Every `.lua` file also has its own comments
explaining the specifics of what it configures — this README is the map,
the files are the territory.

## How Neovim finds all of this

1. Neovim starts, reads `init.lua` (the entry point).
2. `init.lua` sanity-checks that `git`, `rg` (ripgrep), and `fd` are on
   `$PATH` (telescope/treesitter need them), then calls `require("config")`.
3. `require("config")` resolves to `lua/config/init.lua` (Lua's `require`
   looks for `lua/config/init.lua` or `lua/config.lua` — this repo uses the
   directory form so `config` can hold multiple files). This file:
   - bootstraps **lazy.nvim** (the plugin manager) if it isn't installed yet
   - hands lazy.nvim `{ import = "plugins" }`, which means **every file in
     `lua/plugins/*.lua` is loaded automatically** — there's no manual list
     of plugins to keep in sync anywhere else
   - then requires `config.filetypes`, `config.autocmds`, `config.options`,
     `config.keymaps` (in that order), and an optional `config.custom` for
     machine-local overrides that aren't part of this repo (gitignored,
     doesn't exist yet — see "Adding machine-local config" below)

So there are two independent things happening: **lazy.nvim loading plugins**
(driven entirely by what files exist in `lua/plugins/`), and **this repo's
own config modules** loading on top. Neither list needs to be updated by
hand when you add a file — just drop a new file in the right directory.

## Directory layout

```
init.lua                     entry point, sanity checks, require("config")
lazy-lock.json               pins exact plugin commits (see below)
lua/
  config/
    init.lua                bootstraps lazy.nvim, loads the modules below
    options.lua             vim.opt settings (indentation, search, UI, ...)
    autocmds.lua            general-purpose autocommands (format on save, ...)
    keymaps.lua             general-purpose keymaps (not plugin-specific)
    filetypes.lua           custom filetype detection (Helm, Nunjucks)
    custom.lua              (optional, gitignored) your machine-local tweaks
  plugins/
    *.lua                   one file per plugin (or tightly related group)
```

## Why plugin config is split one-file-per-plugin

Each file in `lua/plugins/` returns a table (or list of tables) describing
one plugin to lazy.nvim: where to get it, when to load it, and how to set
it up. This is the standard "LazyVim-style" layout. The advantages that
matter here:

- **Deleting a plugin is deleting a file.** No hunting through a giant
  `plugins = {...}` list to remove references.
- **Adding a plugin is adding a file** that returns `{{ "author/repo",
  opts = {...} }}` — copy the shape from any existing file.
- Comments explaining *why* a plugin is configured a certain way live right
  next to that configuration, not in some separate notes file that goes
  stale.

The tradeoff: cross-plugin relationships (e.g. `nvim-cmp` needing
`cmp_nvim_lsp` for capabilities) are expressed via lazy.nvim's `dependencies`
field rather than being obvious from file layout. That's a minor cost for
the readability gained elsewhere.

## Keymaps: where they live

There's a deliberate split:

- **`lua/config/keymaps.lua`** — keymaps that are always available and
  don't depend on any specific plugin having activated for the current
  buffer (save, quit, reload config, tmux navigation, telescope pickers,
  tabs).
- **Buffer-local, plugin-triggered keymaps live next to that plugin's
  setup**, registered only when the relevant thing actually attaches:
  - LSP keymaps (`gd`, `gr`, `K`, `<leader>rn`, `<leader>ca`, `[d`/`]d`,
    `<leader>e`) are set in `lua/plugins/lsp.lua` inside an `LspAttach`
    autocmd, so they only exist in buffers that actually have a language
    server attached.
  - Gitsigns keymaps (`]c`/`[c`, `<leader>hs/hr/hp/hb`) are set in
    `lua/plugins/gitsigns.lua`'s `on_attach`, so they only exist in buffers
    gitsigns has attached to (i.e. files inside a git repo).

This means `:map` inside a plain-text buffer won't show LSP mappings, and
you don't get "no LSP client attached" errors from pressing `gd` somewhere
it can't work anyway. When adding a new plugin, ask "does this only make
sense once the plugin is active for *this buffer*?" — if yes, keymap goes
next to the plugin; if it's always meaningful, it goes in `keymaps.lua`.

## Autocommands: always through one augroup

`lua/config/autocmds.lua` puts every autocommand into a single augroup
created with `clear = true`:

```lua
local group = augroup("valerio_autocmds", { clear = true })
autocmd("TextYankPost", { group = group, ... })
```

**Why this matters:** `<leader>r` reloads the whole config via `:so %`.
Without a shared group cleared on each load, every `autocmd(...)` call
would register a *new* instance on top of the old ones each time you
reload — so saving a file would strip trailing whitespace twice, flash the
yank highlight twice, etc. `clear = true` wipes the group's previous
contents before re-registering, making config reloads idempotent. Any new
autocommand you add should go through this same `group`, and any new
per-plugin autocmd group (like `valerio_lsp_attach` in `lsp.lua`) should
follow the same pattern.

What's actually in there: flash yanked text, strip trailing whitespace on
save, format the buffer on save via whatever LSP is attached, stop
filetype plugins from auto-inserting comment leaders on `o`/`O`/Enter,
default to spaces (real tabs for go/sh/lua), a colorcolumn at 80, and
wrap+spellcheck for prose filetypes (commit messages, markdown, text).

## How a new filetype gets colored and completed

This is the flow to understand if you want to add support for a language
Neovim doesn't already know:

1. **Neovim needs to know the file's `filetype`.** For almost everything
   (Go, JSON, YAML, SQL, CSS, HTML, Java, JS/TS, Bash, ...) Neovim's
   built-in filetype detection already handles this by extension. It only
   needed help for two cases that don't map cleanly to an extension:
   - **Helm chart templates** are just `.yaml`/`.tpl` files under a
     `templates/` directory — indistinguishable from plain YAML by
     extension alone. `lua/config/filetypes.lua` uses `vim.filetype.add`
     with a **path pattern** and a **function** (not just a static string)
     that checks for a sibling `Chart.yaml` before deciding the buffer is
     `helm` rather than `yaml`. `values.yaml` next to a `Chart.yaml` gets
     the compound filetype `yaml.helm-values`, which is still treated as
     plain `yaml` by anything matching on `"yaml"` (the part before the
     dot), while `helm_ls` specifically also matches on the full
     `"yaml.helm-values"` string for values-aware completion.
   - **Nunjucks** (`.njk`) has no dedicated treesitter parser or common
     LSP, but its `{{ }}` / `{% %}` syntax is close enough to Jinja2 that
     mapping `.njk` → the `jinja` filetype gives good-enough highlighting
     for free.
   - `lua/config/filetypes.lua` has the full comment explaining the
     `vim.filetype.add` API (`extension`/`filename`/`pattern` keys, string
     or function values) — read that file itself when adding another one.
2. **Treesitter needs the language's parser installed** for syntax
   highlighting. `lua/plugins/treesitter.lua`'s `ensure_installed` list is
   just parser names; nvim-treesitter auto-attaches a parser to any buffer
   whose filetype matches the parser's name. Find a parser name via
   `:lua print(vim.inspect(require("nvim-treesitter.parsers").get_parser_configs()))`
   or by browsing `lua/nvim-treesitter/parsers.lua` in the plugin's repo.
3. **A language server needs to be registered** (optional — plenty of
   filetypes are fine with just treesitter highlighting) in
   `lua/plugins/lsp.lua`'s `servers` table. The key is the *lspconfig*
   server name (not always the same as the treesitter parser name or the
   mason package name!) — find it under `lua/lsp/*.lua` in the
   nvim-lspconfig repo, or `:help lspconfig-all`. `{}` means "use its
   defaults"; mason installs the underlying binary automatically the first
   time a matching file is opened.

None of these three steps depend on the others — a language can have
treesitter highlighting with no LSP (Nunjucks), or (in theory) an LSP with
no treesitter parser. Add only what you need.

## The LSP setup, and a real bug found while building it

`lua/plugins/lsp.lua` wires up three plugins together: **mason.nvim**
(installs LSP server binaries), **mason-lspconfig.nvim** (bridges mason ↔
nvim-lspconfig, knows which mason package backs which server name), and
**nvim-lspconfig** (ships default per-server configs and filetype
associations that Neovim's native LSP client reads).

The version of `mason-lspconfig` pinned in `lazy-lock.json` is a fairly
recent one (**v2.3.0**, requires Neovim ≥ 0.11) that works differently from
most tutorials/blog posts you'll find, which show an older pattern:

```lua
-- OLD pattern — does NOT reliably apply custom settings on this version
require("lspconfig")[server].setup(opts)
```

The version installed here instead expects the **native Neovim 0.11 API**:

```lua
vim.lsp.config("*", { capabilities = capabilities })  -- defaults for every server
vim.lsp.config("gopls", { settings = { gopls = {...} } }) -- per-server override
require("mason-lspconfig").setup({ ensure_installed = {...} })  -- installs + auto vim.lsp.enable()
```

`mason-lspconfig`'s `automatic_enable` feature (on by default) calls
`vim.lsp.enable()` for every server mason has installed, using whatever was
registered via `vim.lsp.config()`. It does **not** go through a manual
per-server `.setup()` call at all for servers mason already knows about —
which is basically all of them.

**How this was caught:** while adding new language servers, I opened a Go
file against the real, already-installed plugins and inspected the
attached client directly:

```lua
:lua local c = vim.lsp.get_clients({name="gopls"})[1]; print(vim.inspect(c.config.settings))
```

Under the old manual-loop code this printed only
`{ gopls = { semanticTokens = true } }` — mason-lspconfig's own bundled
default — with **none** of this config's custom `analyses`/`staticcheck`/
`gofumpt` settings, and no `cmp_nvim_lsp` capabilities either. Two bugs
compounded:

1. The setup mechanism itself (manual loop) doesn't apply to servers
   enabled via `automatic_enable`, on this plugin version.
2. Separately, the settings were nested wrong: `gopls` reads its options
   from `settings.gopls.*`, not from the top level of the client config —
   so even fixing (1) alone wouldn't have been enough.

After switching to `vim.lsp.config()`/`vim.lsp.enable()` and fixing the
nesting, the same inspection command shows the real settings applied. This
is the kind of thing that's very easy to configure two different-but-both-
wrong ways and never notice, because the server still starts and still
does *something* — just not what you asked for. **Lesson: when in doubt
about whether an LSP setting is actually applying, inspect
`vim.lsp.get_clients()[i].config` directly rather than trusting that no
error means it worked.**

## Completion (nvim-cmp)

`nvim-cmp` only loads on `InsertEnter` (no need for it until you're
actually typing). Its sources, in priority order: LSP, snippets
(LuaSnip + friendly-snippets for ready-made vscode-style snippets),
buffer words (skipped for buffers over 1MB, to avoid scanning huge files
on every keystroke), Lua API completion, and file paths. `<Tab>`/`<S-Tab>`
do double duty: cycle completion items if the menu is open, otherwise
jump through snippet placeholders, otherwise behave like a normal tab.

## Formatting: one mechanism, not several

Format-on-save is handled by a single autocmd in `autocmds.lua` calling
`vim.lsp.buf.format()` — whatever LSP client is attached to the buffer
does the formatting. There used to be a second plugin (`formatter.nvim` +
`nvim-lint`) fully configured in parallel, but it was never actually wired
to any autocmd or keymap, so it did nothing — just dead weight. Removed
rather than fixed, since one working mechanism beats two, one of which is
silently inert. If you ever need a formatter for a filetype with no LSP
(or whose LSP doesn't support formatting), that's the moment to reach for
a dedicated formatter plugin again — not before.

## Treesitter: only what's backed by an installed parser/plugin

A few options that looked like configuration (`autotag`, `context_commentstring`,
`refactor` blocks, a `nvim-treesitter-textobjects` dependency) were removed
because they were **no-ops**: each depends on a separate plugin
(`nvim-ts-autotag`, `nvim-ts-context-commentstring`,
`nvim-treesitter-refactor`) that was never installed, or on an `opts.textobjects`
table that was never populated. Configuration with no plugin behind it doesn't
error, it just silently does nothing forever — worth grep-ing for periodically.

## What got removed, and why

- **`nvim-tree`** (file tree) — not used; also its keymaps referenced
  undefined globals (`api`, `opts`) and would have errored the moment
  that part of the file loaded, so it was already broken in practice.
- **`formatter.nvim` + `nvim-lint`** — fully configured, never triggered
  by anything (see "Formatting" above).
- Assorted dead options across `treesitter.lua` and `lsp.lua` (see above).

## Bugs fixed that had nothing to do with adding languages

These were found just by reading through the inherited config carefully:

- **Autocommands weren't grouped** → reloading the config duplicated every
  autocommand each time (see "Autocommands" above).
- **`config/init.lua`'s error handling was always a no-op**: the check
  `not mod == "config/custom"` is `(not mod) == "config/custom"` due to
  Lua operator precedence — always `false == "config/custom"`, i.e. always
  false — so genuine startup errors in *any* config module were being
  silently swallowed instead of surfacing. Fixed to `mod ~= "config.custom"`.
- **`mason.setup()` was called twice**: once with real UI/icon options in
  `mason.nvim`'s own plugin file, then again with *no* arguments inside
  `nvim-lspconfig`'s config function — the second call reset mason back to
  its defaults, silently discarding the first call's configuration.
- **`colorscheme.lua` set `opts = ...`** — a bare `...` at the top level of
  a required module has no arguments to expand to, so this evaluated to
  `nil`. Harmless by luck (lazy.nvim treats a missing `opts` as `{}`
  anyway), but meaningless and confusing. Replaced with an actual table.
  Also removed a redundant `config = true` — lazy.nvim already calls
  `require(plugin).setup(opts)` automatically whenever `opts` is present
  and no custom `config` function is given.
- **The lazy.nvim install-time fallback colorscheme list referenced
  `rose-pine`**, which isn't installed anywhere in this config (leftover
  from whatever template this was copied from). Changed to `dracula`,
  which is what's actually configured.

## `lazy-lock.json`: why versions are pinned, and why that matters here

This file records the exact commit lazy.nvim installed for every plugin,
and is what lazy.nvim reads to install those *exact* versions on a fresh
machine (`:Lazy restore`) — not "the latest of everything," which would
mean this config's behavior silently shifts every time you set it up
somewhere new. Do not hand-edit commit hashes; let `:Lazy update` do it
(and note the corresponding change in this repo when it does).

This mattered concretely in this session: the reason the "obvious"
`lspconfig[server].setup()` pattern didn't work (see above) is entirely
because of *which version* is pinned here. A different commit of
`mason-lspconfig` might genuinely need the old pattern. **If you ever run
`:Lazy update`, especially for `mason.nvim`/`mason-lspconfig.nvim`/
`nvim-lspconfig`, re-verify LSP settings are still applying** using the
`vim.lsp.get_clients()` inspection trick shown above — don't assume the
setup code is still correct just because nothing throws an error.

## Adding machine-local config

`lua/config/init.lua` tries to `require("plugins.custom")` and
`require("config.custom")`, and quietly ignores it if either doesn't
exist. If you ever want config that shouldn't be committed (e.g.
work-specific LSP settings, a private colorscheme), create
`lua/plugins/custom.lua` and/or `lua/config/custom.lua` and add them to
`.gitignore` — everything else in this repo assumes they don't exist.

## Languages currently set up

| Language | Highlighting | LSP | Notes |
|---|---|---|---|
| Bash | ✓ | `bashls` | |
| Go | ✓ | `gopls` | custom `analyses`/`staticcheck`/`gofumpt` |
| JSON | ✓ | `jsonls` | |
| YAML | ✓ | `yamlls` | |
| SQL | ✓ | `sqlls` | only attaches with a `.sqllsrc.json` in the project |
| Helm | ✓ (`helm` parser) | `helm_ls` | only attaches inside a chart (`Chart.yaml` present); see `filetypes.lua` |
| JavaScript / TypeScript | ✓ | `ts_ls`, `eslint`, `biome` | |
| Java | ✓ | `jdtls` | |
| Nunjucks (`.njk`) | ✓ (via `jinja` parser) | none | no good dedicated LSP; syntax highlighting only, by design |
| CSS / SCSS | ✓ | `cssls` | |
| HTML | ✓ | `html` | |
| Dockerfile | ✓ | `dockerls` | already present before this pass |
| Vim script | ✓ | `vimls` | already present before this pass |
| Markdown | ✓ | none | already present before this pass |
| Python | ✓ | `ruff` | already present before this pass |

To add another language, follow "How a new filetype gets colored and
completed" above.
