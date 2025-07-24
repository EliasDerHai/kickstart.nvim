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
            checkOnSave = {
              allFeatures = true,
            },
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
      },
    }
  end,
}
