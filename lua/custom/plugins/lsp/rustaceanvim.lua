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
          vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/lldb/lib/liblldb' .. (vim.uv.os_uname().sysname == 'Darwin' and '.dylib' or '.so')
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

        on_attach = function(client, bufnr)
          local opts = { buffer = bufnr }
          -- FIXME: doesn't work yet
          vim.keymap.set('n', '<leader>dt', function()
            vim.cmd.RustLsp 'testables'
          end, vim.tbl_extend('force', opts, { desc = 'Debug test' }))

          -- FIXME: doesn't work yet
          vim.keymap.set('n', '<leader>dr', function()
            vim.cmd.RustLsp { 'testables', bang = true }
          end, vim.tbl_extend('force', opts, { desc = 'Rerun last test' }))

          -- Override :LspRestart in Rust buffers — rust-analyzer is managed by
          -- rustaceanvim outside vim.lsp.config, so the built-in command errors.
          vim.api.nvim_buf_create_user_command(bufnr, 'LspRestart', function()
            local clients = vim.lsp.get_clients { bufnr = 0, name = 'rust-analyzer' }
            for _, client in ipairs(clients) do
              vim.lsp.stop_client(client.id, true)
            end
            vim.defer_fn(function()
              vim.cmd 'edit' -- re-triggers FileType autocmd → rustaceanvim restarts
            end, 1000)
          end, { desc = 'Restart rust-analyzer via rustaceanvim' })

          vim.keymap.set('n', '<leader>rw', function()
            vim.cmd.RustLsp 'reloadWorkspace'
          end, vim.tbl_extend('force', opts, { desc = 'Reload rust-analyzer workspace' }))
        end,
      },
    }
  end,
}
