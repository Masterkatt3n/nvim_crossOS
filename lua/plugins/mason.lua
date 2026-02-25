-- ~/.config/nvim/lua/plugins/mason.lua
return {
  "mason-org/mason.nvim",
  dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  event = "LspAttach",
  config = function()
    require("mason").setup()
    require("mason-tool-installer").setup({
      ensure_installed = {
        "shfmt",
        "prettier",
        "eslint_d",
        "shellcheck",
        --   "tree-sitter-cli",
        --   "stylua",
      },
      auto_update = false,
      run_on_start = true,
    })
  end,
}
