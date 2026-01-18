-- "~/.config/nvim/lua/plugins/lua.lua"
local with_defaults = require("config.lsp.helpers").with_defaults
---@type string[]
local ft_code = require("config.ftypes.filetypes").code

---@type LazyPluginSpec
return {
  -- LSP server for Lua
  {
    "neovim/nvim-lspconfig",
    ft = ft_code,
    event = { "BufReadPre", "BufNewFile" },
    ---@class PluginLspOpts
    opts = {
      servers = {
        lua_ls = with_defaults {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = {
                globals = { "vim", "wezterm" },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  vim.fn.stdpath "config" .. "/lua/types",
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                },
              },
              hint = {
                enable = true,
                setType = true,
                paramType = true,
                semicolon = "Disable",
              },

              codeLens = { enable = true },

              completion = {
                callSnippet = "Replace",
              },
              telemetry = {
                enable = false,
              },
              format = { enable = false },
            },
          },
        },
      },
    },
  },
}
