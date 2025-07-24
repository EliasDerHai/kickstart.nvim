return {
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
    vim.fn.sign_define('DapBreakpoint', {
      text = '🟠',
      texthl = 'DapBreakpointSign',
      linehl = '',
      numhl = '',
    })
    vim.api.nvim_set_hl(0, 'DapBreakpointSign', { fg = '#FFA500' })
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
}
