-- lua/plugins/treesitter.lua
vim.g.tree_sitter_cli_install_path = vim.fn.exepath "tree-sitter"
---@type LazySpec
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
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "dockerfile",
        "gitignore",
        "c",
        "rust",
        "powershell",
        "regex",
        "xml",
        "python",
        "query",
        "php",
        "make",
        "cmake",
        "luadoc",
        "latex",
      })
      opts.matchup = {
        enable = true,
      }
    end,
  },
}
