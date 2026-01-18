-- ~/.config/nvim/lua/config/diagnostics.lua
-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Diagnostic config
vim.diagnostic.config {
  virtual_text = {
    spacing = 6,
    prefix = "⚠️ ",
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
  float = {
    border = "rounded",
    focusable = true,
    source = true,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

-- Keymap for line diagnostics
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { desc = "Show line diagnostics" })

-- === Semantic Token Highlights ===
-- Make sure LSP semantic highlighting cooperates with your colorscheme
local links = {
  ["@lsp.type.variable"] = "@variable",
  ["@lsp.type.parameter"] = "@parameter",
  ["@lsp.type.property"] = "@property",
  ["@lsp.type.function"] = "@function",
  ["@lsp.type.method"] = "@method",
  ["@lsp.type.enum"] = "@type",
  ["@lsp.type.enumMember"] = "@constant",
  ["@lsp.type.interface"] = "@interface",
  ["@lsp.type.namespace"] = "@namespace",
}

for newgroup, oldgroup in pairs(links) do
  vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end
