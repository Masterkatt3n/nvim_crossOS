-- lua/plugins/treesitter.lua
vim.g.tree_sitter_cli_install_path = vim.fn.exepath("tree-sitter")
return {
  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs",
    build = ":TSUpdate",
    event = { "BufReadPost" },

    dependencies = {
      {
        "HiPhish/rainbow-delimiters.nvim",
        event = "BufReadPost",
        config = function()
          vim.g.rainbow_delimiters = {
            strategy = {
              [""] = require("rainbow-delimiters").strategy["global"],
            },
            highlight = {
              "RainbowDelimiterRed",
              "RainbowDelimiterYellow",
              "RainbowDelimiterBlue",
              "RainbowDelimiterOrange",
              "RainbowDelimiterViolet",
              --  "RainbowDelimiterCyan",
              -- "RainbowDelimiterGreen",
            },
          }
        end,
      },
    },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "comment",
        "sql",
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "bash",
        "lua",
        "gitignore",
        "powershell",
        "regex",
        "xml",
        "python",
        "query",
      })
      opts.matchup = {
        enable = true,
      }
    end,
  },
}
