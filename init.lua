-- This needs to be first
require 'opts'

require 'commands'
require 'autocmds'
require 'lazyvim'

-- Do this after loading plugins to override them
--  Those that are loaded lazily needs more care
require 'mappings'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
