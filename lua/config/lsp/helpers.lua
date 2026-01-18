-- ~/.config/nvim/lua/config/lsp/helpers.lua
local M = {}

function M.with_defaults(config)
  config = config or {}
  config.capabilities = require("config.lsp.capabilities").get()

  config.on_attach = function(client, bufnr)
    -- optional: if you still have semantic_cmp, keep it
    local ok_semantic, semantic_cmp = pcall(require, "config.lsp.semantic_cmp")
    if ok_semantic and semantic_cmp.setup then
      semantic_cmp.setup(client, bufnr)
    end

    -- Ruff workaround: disable false semanticTokens support + redundant hover
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- Snacks integration (optional, safe)
    local ok, snacks_lsp = pcall(require, "snacks.util.lsp")
    if ok and snacks_lsp.on then
      snacks_lsp.on(client, function(arg)
        local captable = type(arg) == "table" and arg or client.server_capabilities
        if captable and captable.semanticTokensProvider then
          vim.notify(("Semantic tokens enabled for %s"):format(client.name), vim.log.levels.DEBUG)
        end
      end)
    end
  end

  return config
end

return M
