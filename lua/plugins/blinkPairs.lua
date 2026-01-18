-- ~/.config/nvim/lua/plugins/blinkPairs.lua
return {
  "saghen/blink.pairs",
  event = "InsertEnter",
  build = "cargo build --release",
  version = "*",

  --- @module 'blink.pairs'
  --- @type blink.pairs.Config
  opts = {
    mappings = {
      enabled = true,
      cmdline = true,
      disabled_filetypes = {},
      pairs = {},
    },
    highlights = {
      enabled = true,
      cmdline = true,
      groups = {
        "BlinkPairsOrange",
        "BlinkPairsPurple",
        "BlinkPairsBlue",
      },
      unmatched_group = "BlinkPairsUnmatched",

      matchparen = {
        enabled = true,
        cmdline = false,
        include_surrounding = false,
        group = "BlinkPairsMatchParen",
        priority = 250,
      },
    },
    debug = false,
  },
}
