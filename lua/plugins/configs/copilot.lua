--@type copilot_config
local options = {
  suggestion = {
    enabled = true,
    auto_trigger = false,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  }
}

return options