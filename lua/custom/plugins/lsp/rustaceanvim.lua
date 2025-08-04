return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  dependencies = { 'mfussenegger/nvim-dap' },
  init = function()
    vim.g.rustaceanvim = {
      tools = {
        enable_clippy = true,
      },
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            check = {
              command = 'clippy',
              extraArgs = { '--', '--no-deps' },
            },
            rustfmt = {
              extraArgs = { '+nightly' },
            },
          },
        },
      },
    }
  end,
}
