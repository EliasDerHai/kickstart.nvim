-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  -- AUTOPAIRS () "" '' etc.
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  -- MARKDOWN PREVIEW
  {
    -- Install markdown preview, use npx if available.
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function(plugin)
      if vim.fn.executable 'npx' then
        vim.cmd('!cd ' .. plugin.dir .. ' && cd app && npx --yes npm install')
      else
        vim.cmd [[Lazy load markdown-preview.nvim]]
        vim.fn['mkdp#util#install']()
      end
    end,
    init = function()
      if vim.fn.executable 'npx' then
        vim.g.mkdp_filetypes = { 'markdown' }
      end
    end,
  },
  -- FILE TREE
  {
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
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      }
    end,
  },
}
