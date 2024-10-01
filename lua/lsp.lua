---@diagnostic disable-next-line: undefined-global
local vim = vim

return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },

  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        map('gd', vim.lsp.buf.definition, 'Goto Definition')
        -- Find references for the word under your cursor.
        map('gr', vim.lsp.buf.references, 'Goto References')
        -- Jump to the implementation of the word under your cursor.
        map('gI', vim.lsp.buf.implementation, 'Goto Implementation')
        -- Diagnostic keymaps
        map('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
        map(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')

        map('<leader>ld', function()
          vim.diagnostic.open_float { border = 'rounded' }
        end, 'Show diagnostic Error messages')

        map('<leader>lq', function()
          vim.diagnostic.setloclist { border = 'rounded' }
        end, 'Open diagnostic Quickfix list')

        -- Rename the variable under your cursor.
        map('<leader>lr', vim.lsp.buf.rename, 'Rename')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>la', vim.lsp.buf.code_action, 'Code Action')

        map('<leader>lf', function()
          vim.lsp.buf.format { async = true }
        end, 'Code Format')

        -- Opens a popup that displays documentation about the word under your cursor
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local servers = {
      clangd = {},
      fortls = {},
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            check = {
              allTargets = false
            }
          }
        }
      },
      python_lsp_server = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            diagnostics = {
              globals = {'vim'}
            }
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    require('mason').setup()
    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
