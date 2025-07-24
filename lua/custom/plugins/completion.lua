return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
        },
      }
    end,
  },
  {
    'Exafunction/windsurf.vim',
    cmd = { 'CodeiumToggle' },
    keys = {
      {
        '<leader><CR>',
        function()
          vim.cmd 'CodeiumToggle'
        end,
        desc = 'Toggle Codeium',
      },
    },
    config = function()
      vim.g.codeium_enabled = false
      vim.api.nvim_create_user_command('CodeiumChat', function(opts)
        vim.api.nvim_call_function('codeium#Chat', {})
      end, {})
      vim.g.codeium_no_map_tab = false
      vim.keymap.set('i', '<Tab>', function()
        return vim.fn['codeium#Accept']() .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-j>', function()
        return vim.fn['codeium#CycleCompletions'](1)
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-k>', function()
        return vim.fn['codeium#CycleCompletions'](-1)
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-d>', function()
        return vim.fn['codeium#Clear']()
      end, { expr = true, silent = true })
      vim.o.statusline = table.concat {
        '%f',
        ' %h',
        ' %m',
        ' %r',
        '%=',
        ' %y ',
        '%{&ff} ',
        ' %p%%',
        ' %l:%c ',
        ' [Codeium:%{v:lua.get_codeium_status()}]',
      }
    end,
  },
}
