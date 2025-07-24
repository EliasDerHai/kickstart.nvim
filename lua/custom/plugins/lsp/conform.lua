return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      local disable_filetypes = { 'c', 'cpp', 'sql', 'psql', 'plsql' }
      if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
        return false
      end
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      ocaml = { 'ocamlformat' },
      javascript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      json = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      css = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      html = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      sql = { 'pg_format' },
      psql = { 'pg_format' },
      plsql = { 'pg_format' },
    },
    formatters = {
      pg_format = {
        inherit = true,
        command = 'pg_format',
        args = {
          '--keep-newline',
        },
      },
    },
  },
}