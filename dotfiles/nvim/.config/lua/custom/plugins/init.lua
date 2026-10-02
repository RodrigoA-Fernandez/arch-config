-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    opts = {
      git = {
        enable = true,
      },

      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
      disable_netrw = false,
      hijack_netrw = false,
    },
    config = function()
      require('nvim-tree').setup()
      vim.keymap.set('n', '<leader>tt', '<Cmd>NvimTreeToggle<CR>', { desc = '[T]oggle file[T]ree' })
    end,
  },
  'christoomey/vim-tmux-navigator',
  'nvim-treesitter/nvim-treesitter-context',
  'tpope/vim-fugitive',
  {
    'olexsmir/gopher.nvim',
    ft = 'go',
    config = function(_, opts)
      vim.cmd.GoInstallDeps()
      require('gopher').setup(opts)
      vim.keymap.set('n', '<leader>gsj', '<cmd> GoTagAdd json<CR>', { desc = 'Add [G]o [S]truct tags for [J]son' })
      vim.keymap.set('n', '<leader>gsy', '<cmd> GoTagAdd yaml<CR>', { desc = 'Add [G]o [S]truct tags for [Y]aml' })
      vim.keymap.set('n', '<leader>ge', '<cmd> GoIfErr<CR>', { desc = 'Add [G]o if [E]rr' })
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  -- {
  -- 	"ellisonleao/gruvbox.nvim",
  -- 	lazy = false,
  -- 	config = true,
  -- 	priority = 1000,
  -- 	config = function()
  -- 		vim.o.background = "dark"
  -- 		vim.cmd("colorscheme gruvbox")
  -- 	end,
  -- },
  'Soares/base16.nvim',
  {
    'ZSaberLv0/ZFVimDirDiff',
    dependencies = {
      'ZsaberLv0/ZFVimJob',
      'ZsaberLv0/ZFVimIgnore',
      'ZsaberLv0/ZFVimBackup',
    },
  },
  'mbbill/undotree',
  'RRethy/base16-nvim',
}
