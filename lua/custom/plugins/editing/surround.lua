return {
  'kylechui/nvim-surround',
  version = '^3.1.2',
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup {}
  end,
}
