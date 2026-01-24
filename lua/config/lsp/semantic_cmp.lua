-- ~/.config/nvim/lua/config/lsp/semantic_cmp.lua
local M = {}

--- Attach semantic tokens + blink.cmp if supported
---@param client vim.lsp.Client
---@param bufnr integer
function M.setup(client, bufnr)
  -- Attach blink.cmp only if it's installed and the client supports semantic tokens
  local has_semantic = client.server_capabilities.semanticTokensProvider
  local ok_blink, blink_cmp = pcall(require, "blink.cmp")
  ---@diagnostic disable-next-line: undefined-field
  if ok_blink and has_semantic and blink_cmp.attach then
    ---@diagnostic disable-next-line: undefined-field
    blink_cmp.attach(bufnr)
  end

  -- Define optional semantic highlight groups (colors are examples)
  if has_semantic then
    local hl = vim.api.nvim_set_hl
    hl(0, "LspSemanticFunction", { fg = "#27F5CF", bold = true })
    hl(0, "LspSemanticVariable", { fg = "#0F0BF4" })
  end
end

return M
