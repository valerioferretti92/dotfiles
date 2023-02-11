return {
  -- Gruvbox
  { "ellisonleao/gruvbox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  -- Vim tmux navigator
  { "christoomey/vim-tmux-navigator" },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    opts = function ()
        defaults = {
          mappings = {
            n = {
              ["<C-h>"] = false,
              ["<C-j>"] = false,
              ["<C-k"] = false,
              ["<C-l>"] = false,
            },
          },
        },
    end
  },
}
