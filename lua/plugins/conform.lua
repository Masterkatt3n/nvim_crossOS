-- "~/.config/nvim/lua/plugins/conform.lua"
local data_path = vim.fn.stdpath("data")
local home = vim.fn.expand("HOME")

local stylua_cargo = home .. "/.cargo/bin/stylua"
local stylua_mason = data_path .. "/mason/packages/stylua/stylua"
local Stylua
if vim.fn.executable(stylua_cargo) == 1 then
  Stylua = stylua_cargo
elseif vim.fn.executable(stylua_cargo .. ".exe") == 1 then
  Stylua = stylua_cargo .. ".exe"
elseif vim.fn.executable(stylua_mason) == 1 then
  Stylua = stylua_mason
elseif vim.fn.executable(stylua_mason .. ".cmd") == 1 then
  Stylua = stylua_mason .. ".cmd"
else
  Stylua = "stylua"
end

---@type LazyPluginSpec
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function(_, opts)
    opts.formatters = opts.formatters or {}
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    opts.formatters.stylua = {
      command = Stylua,
    }

    opts.formatters.powershell = {
      command = "pwsh",
      args = {
        "-NoProfile",
        "-NonInteractive",
        "-Command",
        [[
    $code = [Console]::In.ReadToEnd()
    $result = Invoke-Formatter -Settings CodeFormattingOTBS -ScriptDefinition $code
    [Console]::Out.Write($result)
    ]],
      },
      stdin = true,
    }

    -- Attach it to filetypes
    opts.formatters_by_ft.javascript = { "prettier" }
    opts.formatters_by_ft.typescript = { "prettier" }
    opts.formatters_by_ft.javascriptreact = { "prettier" }
    opts.formatters_by_ft.typescriptreact = { "prettier" }
    opts.formatters_by_ft.css = { "prettier" }
    opts.formatters_by_ft.html = { "prettier" }
    opts.formatters_by_ft.json = { "prettier" }
    opts.formatters_by_ft.yaml = { "prettier" }
    opts.formatters_by_ft.markdown = { "prettier" }
    opts.formatters_by_ft.sh = { "shfmt" }
    opts.formatters_by_ft.bash = { "shfmt" }
    opts.formatters_by_ft.lua = { "stylua" }
    opts.formatters_by_ft.python = { "ruff_fix", "ruff_format", "ruff_organize_imports" }
    opts.formatters_by_ft.xml = { "xmlformat" }
    opts.formatters_by_ft.fish = {}
    opts.formatters_by_ft.powershell = { "powershell" }
    opts.formatters_by_ft.ps1 = { "powershell" }
    opts.formatters_by_ft.psm1 = { "powershell" }
  end,

  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 5000,
        })
      end,
      mode = { "n", "v" },
      desc = "Format file or range (in visual mode)",
    },
  },
}
