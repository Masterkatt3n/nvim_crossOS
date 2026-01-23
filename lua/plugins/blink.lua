-- "lua/plugins/blink.lua"
return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*", -- use a release tag to download pre-built binaries
  -- AND/OR build from source
  build = "cargo build --release",
  event = { "InsertEnter", "CmdlineEnter" }, -- defer until insert mode
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "super-tab" },
    appearance = { nerd_font_variant = "mono" },
    completion = { documentation = { auto_show = false } },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
