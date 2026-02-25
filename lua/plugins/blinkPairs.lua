-- ~/.config/nvim/lua/plugins/blinkPairs.lua
return {
  "saghen/blink.pairs",
  event = "InsertEnter",
  -- workaround until fix upstream
  build = "cargo +nightly-2026-01-24 build --release",
  -- build = "cargo build --release",
  -- uncomment deps to fetch binaries(..and comment out the build line)
  --  dependencies = "saghen/blink.download",
  version = "*", -- only required with prebuilt binaries

  --- @module "blink.pairs"
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
        -- "BlinkPairsOrange",
        "BlinkPairsCyan",
        "BlinkPairsGreen",
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
