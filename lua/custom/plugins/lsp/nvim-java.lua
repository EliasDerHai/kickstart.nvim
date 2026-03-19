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
            format = {
              enabled = true,
              settings = {
                profile = 'GoogleStyle',
                url = 'https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml',
              },
            },
          },
        },
      },
    })
    vim.lsp.enable('jdtls')
  end,
}
