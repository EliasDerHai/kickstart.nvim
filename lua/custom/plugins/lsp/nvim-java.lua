return {
  'nvim-java/nvim-java',
  config = function()
    require('java').setup({
      lombok = {
        enable = true,
        version = '1.18.40',
      },
      spring_boot_tools = {
        enable = false,
      },
      jdtls = {
        settings = {
          java = {
            completion = {
              maxResults = 20,
              matchCase = 'off',
            },
          },
        },
      },
    })
    vim.lsp.enable('jdtls')
  end,
}
