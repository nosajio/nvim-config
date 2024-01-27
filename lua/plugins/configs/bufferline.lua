-- @type bufferline.Config
local options = {
  options = {
    hover = {
      enabled = true,
      delay = 150,
      reveal = {'close'}
    },

    close_command = function(bufid) vim.api.nvim_buf_delete(bufid, {force = true}) end,
  }
}

return options
