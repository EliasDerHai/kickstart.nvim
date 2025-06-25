local Plugin = { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' }

function Plugin.config()
  require('bufferline').setup {
    options = {
      -- Enable LSP diagnostics
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level, _, _)
        local icon = level:match 'error' and ' ' or ' '
        return ' ' .. icon .. count
      end,
    },
  }
end

return Plugin
