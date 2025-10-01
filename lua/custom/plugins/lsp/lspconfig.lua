return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- Set up an autocommand group for LSP-related events.
    local lsp_augroup = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true })

    -- This function runs whenever an LSP attaches to a buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = lsp_augroup,
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        -- Helper function to create buffer-local keymaps.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        --
        -- Navigation and Information
        --
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        --
        -- Symbol Search
        --
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        --
        -- Code Actions
        --
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

        --
        -- Toggles and UI
        --
        local diagnostics_mode = 'all'
        local function toggle_diagnostics_mode()
          if diagnostics_mode == 'all' then
            vim.diagnostic.config {
              virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
              signs = { severity = { min = vim.diagnostic.severity.ERROR } },
              underline = { severity = { min = vim.diagnostic.severity.ERROR } },
              update_in_insert = false,
            }
            diagnostics_mode = 'errors'
            print 'Diagnostics: Showing only errors'
          else
            vim.diagnostic.config {
              virtual_text = true,
              signs = true,
              underline = true,
              update_in_insert = false,
            }
            diagnostics_mode = 'all'
            print 'Diagnostics: Showing all (errors + warnings)'
          end
        end
        map('<leader>td', toggle_diagnostics_mode, '[T]oggle [D]iagnostics')

        if client and client.supports_method 'textDocument/inlayHint' then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
          end, '[T]oggle Inlay [H]ints')
        end

        --
        -- Automatic Highlighting on Cursor Hold
        --
        if client and client.supports_method 'textDocument/documentHighlight' then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          -- Clean up the highlight group when the LSP detaches.
          vim.api.nvim_create_autocmd('LspDetach', {
            group = lsp_augroup,
            buffer = bufnr,
            callback = function()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = bufnr }
            end,
          })
        end
      end,
    })

    --
    -- Global Diagnostic Configuration
    --
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local message_map = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return message_map[diagnostic.severity]
        end,
      },
    }

    --
    -- LSP Server Setup
    --
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      -- angularls = { filetypes = { 'html', 'typescript' } },
      dockerls = {},
      docker_compose_language_service = {},
      elixirls = {},
      helm_ls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
          },
        },
      },
    }

    --
    -- Mason and Server Installation
    --
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, {
      'stylua',
      'prettierd',
      'prettier',
      'shellcheck',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {
        'eslint',
        'lua_ls',
        'pyright',
      },
      automatic_installation = true,
      automatic_enable = {
        exclude = {
          'rust_analyzer',
          'ts_ls', -- ts_ls' inlay_hints don't work, using typescrip_tools instead
        },
      },
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    -- TODO: looks good, doesn't work
    vim.lsp.config('tailwindcss', {
      capabilities = capabilities,
      filetypes = { 'gleam', 'html' },
      settings = {
        tailwindCSS = {
          classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass', 'attribute.class' },
          includeLanguages = {
            eelixir = 'html-eex',
            eruby = 'erb',
            htmlangular = 'html',
            templ = 'html',
            gleam = 'javascript',
          },
          lint = {
            cssConflict = 'warning',
            invalidApply = 'error',
            invalidConfigPath = 'error',
            invalidScreen = 'error',
            invalidTailwindDirective = 'error',
            invalidVariant = 'error',
            recommendedVariantOrder = 'warning',
          },
          validate = true,
        },
      },
    })
    vim.lsp.enable('tailwindcss')

    --
    -- LSPs which aren't on Mason
    --

    -- Setup ocamllsp if available
    if vim.fn.executable 'ocamllsp' == 1 then
      servers.ocamllsp = { capabilities = capabilities }
    end

    -- Setup gleam if available
    if vim.fn.executable 'gleam' == 1 then
      vim.lsp.config('gleam', {})
      vim.lsp.enable('gleam')
    end
  end,
}
