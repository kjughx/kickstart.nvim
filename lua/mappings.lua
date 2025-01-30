local map = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, { desc = desc or "" })
end

local map_expr = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, { expr = true })
end

map('n', '<leader>w', '<cmd>w<CR>', 'Save buffer')
map('n', '<leader>q', '<cmd>q<CR>', 'Close buffer')

map('v', '<', '<gv')
map('v', '>', '>gv')

map('n', '<C-j>', ':m +1<CR>==')
map('n', '<C-k>', ':m -2<CR>==')
map('v', '<C-j>', ":m '>+1<CR>gv=gv")
map('v', '<C-k>', ":m '<-2<CR>gv=gv")

map('n', '<leader>e', '<cmd>Lexplore<CR>', 'Open netrw')
map('n', '<leader>h', '<cmd>nohlsearch<CR>', 'Clear highlighting')

map('n', ']b', '<cmd>bnext<CR>', 'Next buffer')
map('n', '[b', '<cmd>bprevious<CR>', 'Previous buffer')

map('n', '<leader>bb', '<cmd>ClistBuffers<CR>', 'List open buffers')
map('n', '<leader>bc', "<cmd>bdelete<CR>")

map('n', 'n', [[n:lua require('go-up').centerScreen()<CR>]])
map('n', 'N', [[N:lua require('go-up').centerScreen()<CR>]])

function PasteSelectionToCmd()
  local selected_text = vim.fn.getreg('a')
  vim.cmd('call feedkeys(":' .. selected_text .. '\\<Left>\\<C-b> \\<Left>", "n")')
end

vim.api.nvim_set_keymap(
  'x',
  ';',
  '"ay:<C-u>lua PasteSelectionToCmd()<CR>',
  { noremap = true, silent = true }
)
