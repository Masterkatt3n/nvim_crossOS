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
      ghost_text = { enabled = true },
      menu = {
        auto_show = true,
        draw = {
          padding = { 0, 1 }, -- padding only on right side
          treesitter = { "lsp" },
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
            kind = {
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },

      documentation = { auto_show = false },
      list = {
        selection = {
          ---@diagnostic disable-next-line: unused-local
          preselect = function(_ctx)
            return not require("blink.cmp").snippet_active({ direction = 1 })
          end,
        },
      },
      accept = { auto_brackets = { enabled = true } },
    },

    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },

  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },
}
