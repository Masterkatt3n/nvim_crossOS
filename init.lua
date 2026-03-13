-- "~/.config/nvim/init.lua"
-- optional python3 provider pointer
local is_win = vim.fn.has("win32") == 1

local py_host

if is_win then
  py_host = vim.fn.expand("$HOME/AppData/Local/Programs/Python/Python313/python.exe") -- common path on Windows, might need editing
else
  local venv_python = vim.fn.expand("$HOME/.venv/bin/python")
  py_host = vim.fn.filereadable(venv_python) == 1 and venv_python or vim.fn.exepath("python3")
end

if py_host then
  vim.g.python3_host_prog = py_host
end

vim.g.loaded_matchit = 1
-- optional, disables perl and ruby provider
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- nvim log | Debug
-- vim.api.nvim_command "set verbosefile=$HOME\\nvim-startup.log"
-- vim.api.nvim_command "set verbose=15"

require("config.options")
require("config.keymaps")
require("config.diagnostics")
require("config.lazy")
