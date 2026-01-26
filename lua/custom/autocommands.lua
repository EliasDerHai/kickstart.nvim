-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Automatically enter insert mode when opening a terminal
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open-insert', { clear = true }),
  pattern = '*',
  command = 'startinsert',
  desc = 'Automatically enter insert mode when opening a terminal',
})

-- Automatically enter insert mode when focusing a terminal buffer
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('custom-term-focus-insert', { clear = true }),
  pattern = '*',
  callback = function(event)
    if vim.bo[event.buf].buftype == 'terminal' then
      vim.cmd 'startinsert'
    end
  end,
  desc = 'Automatically enter insert mode when focusing a terminal buffer',
})
