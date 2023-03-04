require "globals"
require "mappings"

local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  -- lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
	{ 
		'ellisonleao/gruvbox.nvim' 
	},
	{ 
		'nvim-lualine/lualine.nvim' 
	},
	{ 
		'christoomey/vim-tmux-navigator'
	},
	{
		'nvim-telescope/telescope.nvim', 
		tag = '0.1.1', 
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
})

require "plugins-config"
