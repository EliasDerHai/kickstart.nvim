return {
  -- Rust advanced
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      -- in your dap setup (e.g. right after require("dap"))
      -- Orange circle for breakpoints
      vim.fn.sign_define('DapBreakpoint', {
        text = '🟠',
        texthl = 'DapBreakpointSign',
        linehl = '',
        numhl = '',
      })
      vim.api.nvim_set_hl(0, 'DapBreakpointSign', { fg = '#FFA500' })

      -- Strong highlight for the current stopped line
      vim.fn.sign_define('DapStopped', {
        text = '▶️',
        texthl = 'DapStoppedSign',
        linehl = 'DapStoppedLine',
        numhl = 'DapStoppedSign',
      })
      vim.api.nvim_set_hl(0, 'DapStoppedSign', { fg = '#FFFFFF', bg = '#FF4500', bold = true })
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#3A1F1F', bold = true })

      require('dapui').setup()
      require('nvim-dap-virtual-text').setup()

      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set('n', '<leader>gb', dap.run_to_cursor, { desc = 'Run to cursor' })
      vim.keymap.set('n', '<leader>?', function()
        require('dapui').eval(nil, { enter = true })
      end, { desc = 'Evaluate expression' })

      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Start/Continue debugging' })
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Step over' })
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Step into' })
      vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Step out' })
      vim.keymap.set('n', '<F7>', dap.restart, { desc = 'Restart debugging' })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      }
    end,
  },

  -- AUTOPAIRS () "" '' etc. -> trying to replace with nvim.surround
  -- {
  --   'windwp/nvim-autopairs',
  --   event = 'InsertEnter',
  --   config = true,
  -- },
  -- MARKDOWN PREVIEW
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
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
          -- dotfiles = true,
        },
      }

      vim.keymap.set('n', '<leader>z', ':NvimTreeFindFile<CR>', { noremap = true, silent = true, desc = 'find file in tree' })
    end,
  },
}
