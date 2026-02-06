-- "~/.config/nvim/lua/plugins/lsp.lua"
local with_defaults = require("config.lsp.helpers").with_defaults
---@type string[]
local ft_all = require("config.ftypes.filetypes").all
local logpath = vim.fn.stdpath("state") .. "/PSesLogs/pses.log"
local sessionpath = vim.fn.stdpath("state") .. "/PSesLogs/session.json"

local data_path = vim.fn.stdpath("data")

local bundlepath
bundlepath = data_path .. "/mason/packages/powershell-editor-services"
local pwshpath = bundlepath .. "/PowerShellEditorServices/Start-EditorServices.ps1"

return {
  "neovim/nvim-lspconfig",
  ft = ft_all,
  event = { "BufReadPre", "BufNewFile" },
  ---@class PluginLspOpts
  opts = {
    servers = {
      pyright = with_defaults({
        settings = {
          pyright = { disableOrganizeImports = true },
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              -- ignore = { "*" }, -- uncomment if you want Ruff to *fully* replace Pyright linting
            },
          },
        },
      }),
      ruff = with_defaults({
        cmd = { "ruff", "server", "--preview" },
        settings = { organizeImports = false },
        init_options = {
          settings = {
            logLevel = "info", -- can be "debug" for troubleshooting
          },
        },
      }),
      jsonls = with_defaults(),
      yamlls = with_defaults({ filetypes = { "yaml" } }),
      taplo = with_defaults({ cmd_env = { RUST_LOG = "error" } }),
      marksman = with_defaults({ filetypes = { "markdown" } }),
      bashls = with_defaults({
        autostart = false,
        settings = { bashIde = { shellcheckPath = "" } },
      }),
      powershell_es = with_defaults({
        bundle_path = bundlepath,
        cmd = {
          "pwsh",
          "-NoLogo",
          "-NoProfile",
          "-Command",
          pwshpath,
          "-LogLevel",
          "Warning",
          "-LogPath",
          logpath,
          "-SessionDetailsPath",
          sessionpath,
          "-Stdio",
        },
        filetypes = { "ps1" },
        settings = {
          powershell = {
            codeFormatting = {
              preset = "OTBS",
              openBraceOnSameLine = true,
              addWhitespaceAroundPipe = true,
              pipelineIndentation = "IncreaseIndentationForFirstPipeline",
              useCorrectCasing = true,
            },
            scriptAnalysis = {
              enable = true,
              settingsPath = nil,
              diagnosticSeverity = {
                Information = "Information",
                Warning = "Warning",
                Error = "Error",
              },
            },
          },
        },
      }),
    },
  },
}
