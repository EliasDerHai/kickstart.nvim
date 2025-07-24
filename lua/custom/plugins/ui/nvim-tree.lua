return {
  'nvim-tree/nvim-tree.lua',
  version = '1.11',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      sort = {
        sorter = 'case_sensitive',
      },
      git = {
        enable = true,
        ignore = false,
      },
      view = {
        width = 50,
        adaptive_size = false,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        custom = { '.DS_Store' },
      },
    }

    vim.keymap.set('n', '<leader>z', ':NvimTreeFindFile<CR>', { noremap = true, silent = true, desc = 'find file in tree' })
  end,
}
