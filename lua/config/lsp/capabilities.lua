-- ~/.config/nvim/lua/config/lsp/capabilities.lua
local M = {}

function M.get()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Encoding capabilities for maximum compatibility
  local encodings = { "utf-16" }

  capabilities.general = capabilities.general or {}
  capabilities.general.positionEncodings = encodings
  ---@diagnostic disable-next-line: inject-field
  capabilities.offsetEncoding = encodings

  -- Try both cmp backends in priority order
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local ok_blink, blink_cmp = pcall(require, "blink.cmp")

  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  elseif ok_blink and blink_cmp then
    if blink_cmp.get_lsp_capabilities then
      capabilities = blink_cmp.get_lsp_capabilities(capabilities)
    elseif blink_cmp.add_capabilities then
      -- fallback for older versions
      capabilities = blink_cmp.add_capabilities(capabilities)
    else
      vim.notify(
        "blink.cmp found but doesn't expose capability helpers",
        vim.log.levels.WARN
      )
    end
  end

  -- Common manual extensions
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return capabilities
end

return M
