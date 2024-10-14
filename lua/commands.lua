vim.api.nvim_create_user_command(
  'Grep',
  function(opts)
    vim.cmd('silent grep! ' .. opts.args)
    vim.cmd('copen 22')
  end,
  { nargs = '+' }
)

vim.cmd("cnoreabbrev rg Grep")

vim.api.nvim_create_user_command("ClistBuffers", function()
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    local qflist = {}

    -- Prepare quickfix list items
    for _, buf in ipairs(buffers) do
        local bufname = buf.name ~= '' and buf.name or '[No Name]'
        local modified = buf.changed == 1 and "[+]" or ""
        table.insert(qflist, {
            text = string.format("%s %s", bufname, modified),
        })
    end

    -- Set the quickfix list with buffer info
    vim.fn.setqflist(qflist, 'r')
    vim.cmd('copen')  -- Open the quickfix window

    -- Focus the quickfix window immediately
    vim.cmd('wincmd j')  -- Jump to the quickfix window

    -- Map 'q' to close the quickfix window
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':cclose<CR>', { noremap = true, silent = true })
end, {})
