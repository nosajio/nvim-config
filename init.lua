require "options"

local loaders = require "utils.loaders"

-- bootstrap plugins & lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim" -- path where its going to be installed

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require "plugins"

-- Load and set mappings
loaders.load_mappings()

-- vim.schedule(function()
--   for _, section in pairs(mappings) do
--     for mode, values in pairs(section) do
--       for keybind, mapping_info in pairs(values) do
--         local operation = mapping_info[1]
--         local opts = mapping_info.opts or {}
--         opts.desc = mapping_info[2]
--         vim.keymap.set(mode, keybind, operation, opts)
--       end
--     end
--   end
-- end)

vim.cmd "colorscheme sequoia"
