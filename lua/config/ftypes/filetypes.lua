-- ~/.config/nvim/lua/config/filetypes.lua"
local M = {}

-- Core coding languages you work with a lot
M.code = {
  "lua",
  "python",
  "powershell",
  "ps1",
  "bash",
  "sh",
}

-- Web / frontend stuff (optional)
M.web = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
  "css",
  "html",
  "json",
  "yaml",
  "toml",
  "dockerfile",
  "docker-compose",
  "csharp",
}

-- Docs / writing
M.docs = {
  "markdown",
  "latex",
}

-- Full stack (merge code + web)
M.all = vim.list_extend(vim.deepcopy(M.code), M.web)

return M
