return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.ai').setup { n_lines = 500 }
    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }
    statusline.section_location = function()
      local ok, harpoon = pcall(require, 'harpoon')
      if ok then
        local list = harpoon:list()
        local current = vim.fn.fnamemodify(vim.fn.expand '%:p', ':.')
        for i, item in ipairs(list.items) do
          if item.value == current then
            return string.format('H:%d  %%2l:%%-2v', i)
          end
        end
      end
      return '%2l:%-2v'
    end
  end,
}
