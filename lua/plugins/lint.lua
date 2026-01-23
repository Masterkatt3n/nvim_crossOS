-- ~/.config/nvim/lua/plugins/lint.lua
---@type string[]
local ft_all = require("config.ftypes.filetypes").all
local lint = require("lint")

return {
  "mfussenegger/nvim-lint",
  ft = ft_all,
  ---@type LazyPluginSpec
  event = { "BufReadPre", "BufWritePost" },
  config = function()
    lint.linters_by_ft = {
      sh = { "shellcheck" },
      bash = { "shellcheck" },
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
