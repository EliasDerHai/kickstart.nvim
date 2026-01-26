-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- paste in vis mode doesn't put deleted content into register (allows for multiple pastes of yanked text)
vim.keymap.set('v', 'p', [["_dP]], { noremap = true, silent = true })

-- Unmap help (f1)
vim.keymap.set('n', '<F1>', '<Esc>')
vim.keymap.set('i', '<F1>', '<Esc>')

-- cleanup buffers
vim.keymap.set('n', '<leader>cb', '<Cmd>BufferLineCloseOthers<CR>', { desc = '[C]lose Other [B]uffers' })
vim.keymap.set('n', '<leader>cc', '<Cmd>bdelete<CR>', { desc = '[C]lose [C]urrent Buffer' })
vim.keymap.set('n', '<leader>cr', '<Cmd>BufferLineCloseRight<CR>', { desc = '[C]lose Buffers to [R]ight' })
vim.keymap.set('n', '<leader>cl', '<Cmd>BufferLineCloseLeft<CR>', { desc = '[C]lose Buffers to [L]eft' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w><C-h>', { desc = 'Move focus to the left window (from terminal)' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w><C-j>', { desc = 'Move focus to the lower window (from terminal)' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w><C-k>', { desc = 'Move focus to the upper window (from terminal)' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w><C-l>', { desc = 'Move focus to the right window (from terminal)' })
