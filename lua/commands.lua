vim.api.nvim_create_user_command(
  'Grep',
  function(opts)
    vim.cmd('silent grep! ' .. opts.args)
    vim.cmd('copen 42')
  end,
  { nargs = '+' }
)
