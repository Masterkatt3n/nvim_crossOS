-- "lua/plugins/blink.lua"
return {
  "saghen/blink.cmp",
  version = not vim.g.lazyvim_blink_main and "*", -- use a release tag to download pre-built binaries
  -- AND/OR build from source OR/GO and get the DL on failure either way
  build = "cargo build --release",
  -- optional: provides snippets for the snippet source
  dependencies = {
    "rafamadriz/friendly-snippets",
    -- add blink.compat to dependencies
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
      version = not vim.g.lazyvim_blink_main and "*",
    },
  },
  event = { "InsertEnter", "CmdlineEnter" }, -- defer until insert mode

  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "super-tab" },
    appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = "mono" },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = false,
      },
    },
  },
  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  fuzzy = { implementation = "prefer_rust_with_warning" },
}
