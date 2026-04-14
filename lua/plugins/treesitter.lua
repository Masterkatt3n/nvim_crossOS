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
        enabled = true,
        event = "BufReadPost",
        config = function()
          vim.g.rainbow_delimiters = {
            highlight = {
              "RainbowDelimiterRed",
              "RainbowDelimiterBlue",
              "RainbowDelimiterYellow",
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
        "sql",
        "xml",
        "lua",
        "css",
        "tsx",
        "json",
        "yaml",
        "html",
        "bash",
        "query",
        "regex",
        "python",
        "comment",
        "gitignore",
        "powershell",
        "javascript",
        "typescript",
      })
      opts.matchup = {
        enable = true,
      }
    end,
  },
}
