-- ~/.config/nvim/lua/config/tracker/oneDhelper.lua

local M = {}

M.styles = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }
M.current = 2 -- "darker"

function M.next()
  M.current = M.current + 1
  if M.current > #M.styles then
    M.current = 1
  end

  local style = M.styles[M.current]

  local onedark = require("onedark")
  onedark.setup({ style = style })
  onedark.load()

  vim.notify("󰔎 " .. style)
end

return M
