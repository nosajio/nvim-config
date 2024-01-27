local M = {}
local loaders = require "utils.loaders"
local lspconfig = require "lspconfig"

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
  loaders.load_mappings("lspconfig", { buffer = bufnr })
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

require("lspconfig").lua_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    }
      -- workspace = {
      --   -- Make the server aware of Neovim runtime files
      --   library = vim.api.nvim_get_runtime_file("", true), 
      -- },
      -- workspace = {
      --   library = {
      --     [vim.fn.expand "$VIMRUNTIME/lua"] = true,
      --     [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
      --     [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
      --   },
      --   maxPreload = 100000,
      --   preloadFileSize = 10000,
      -- },
    -- },
  },
}


-- setup multiple servers with same default options
local servers = { "html", "cssls", "tsserver", "clangd", "eslint" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
  }
end

vim.diagnostic.config({
  virtual_text = false
})

return M
