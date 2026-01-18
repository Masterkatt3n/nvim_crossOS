-- ~/.config/nvim/lua/plugins/mason.lua
return {
  "mason-org/mason.nvim",
  dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  event = "LspAttach",
  config = function()
    require("mason").setup()
    require("mason-tool-installer").setup {
      ensure_installed = {
        "prettier",
        "eslint_d",
        "shellcheck",
        "shfmt",
        "xmlformatter",
        -- "stylua",
      },
      auto_update = false,
      run_on_start = true,
    }
  end,
}
