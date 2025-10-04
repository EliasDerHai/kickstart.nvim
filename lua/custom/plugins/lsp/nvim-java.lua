return {
  'nvim-java/nvim-java',
  config = function()
    vim.lsp.config('java', {})
    vim.lsp.enable 'java'
    vim.lsp.config('jdtls', {})
    vim.lsp.enable 'jdtls'
  end,
}
