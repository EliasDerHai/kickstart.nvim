-- nvm is lazy-loaded in the shell, so nvim inherits a PATH without a node bin
-- dir. Resolve nvm's default version ourselves and prepend its bin, so tools
-- (typescript-tools, formatters) and `npm root -g` see nvm's global installs.
local function setup_nvm_path()
  local nvm_dir = vim.env.NVM_DIR or (vim.env.HOME .. '/.nvm')
  local versions_dir = nvm_dir .. '/versions/node'
  if vim.fn.isdirectory(versions_dir) == 0 then
    return
  end

  -- Read the default alias (e.g. "22", "v22.21.1", "lts/*"); may be absent.
  local alias = ''
  local f = io.open(nvm_dir .. '/alias/default', 'r')
  if f then
    alias = vim.trim(f:read '*a' or '')
    f:close()
  end

  -- Match installed version dirs against the alias, then pick the highest.
  local prefix = alias:match '^v?(%d+)' -- major version from "22" / "v22.21.1"
  local best
  for _, dir in ipairs(vim.fn.readdir(versions_dir)) do
    local match = prefix == nil or dir:match('^v' .. prefix .. '%.') or dir == 'v' .. alias
    if match and (best == nil or dir > best) then
      best = dir
    end
  end

  if best then
    vim.env.PATH = versions_dir .. '/' .. best .. '/bin:' .. vim.env.PATH
  end
end

setup_nvm_path()

-- Load custom configuration
require 'custom.options'
require 'custom.keymaps'
require 'custom.autocommands'

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup {
  spec = {
    -- UI
    { import = 'custom.plugins.ui' },

    -- Editing
    { import = 'custom.plugins.editing' },

    -- LSP
    { import = 'custom.plugins.lsp' },

    -- DAP
    { import = 'custom.plugins.dap' },

    -- Git
    require 'kickstart.plugins.gitsigns',
    -- require 'kickstart.plugins.debug',
    -- require 'kickstart.plugins.indent_line',
    -- require 'kickstart.plugins.lint',
    -- require 'kickstart.plugins.autopairs',
    -- require 'kickstart.plugins.neo-tree',

    -- Telescope
    { import = 'custom.plugins.telescope' },

    -- Completion
    { import = 'custom.plugins.completion' },
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
