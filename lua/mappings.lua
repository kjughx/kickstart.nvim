local map = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, { desc = desc or {} })
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

-- TIP: Disable arrow keys in normal mode
map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', 'Move focus to the left window')
map('n', '<C-l>', '<C-w><C-l>', 'Move focus to the right window')
-- map('n', '<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
-- map('n', '<C-k>', '<C-w><C-k>', 'Move focus to the upper window')
