return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  dependencies = { 'mfussenegger/nvim-dap' },
  init = function()
    vim.g.rustaceanvim = {
      tools = {
        enable_clippy = false,
      },
      dap = {
        adapter = require('rustaceanvim.config').get_codelldb_adapter(
          vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
          vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/lldb/lib/liblldb'
        ),
      },
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            check = {
              command = 'clippy',
              extraArgs = { '--', '--no-deps' },
            },
            checkOnSave = true,
            rustfmt = {
              extraArgs = { '+nightly' },
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
          },
        },

        -- FIXME: doesn't work yet
        on_attach = function(client, bufnr)
          local opts = { buffer = bufnr }
          vim.keymap.set('n', '<leader>dt', function()
            vim.cmd.RustLsp 'testables'
          end, vim.tbl_extend('force', opts, { desc = 'Debug test' }))

          vim.keymap.set('n', '<leader>dr', function()
            vim.cmd.RustLsp { 'testables', bang = true }
          end, vim.tbl_extend('force', opts, { desc = 'Rerun last test' }))
        end,
      },
    }
  end,
}
