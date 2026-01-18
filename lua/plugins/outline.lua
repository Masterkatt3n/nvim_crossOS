-- "~/.config/nvim/lua/plugins/outline.lua"
---@type LazyPluginSpec
return {
  "hedyhli/outline.nvim",
  keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
  cmd = "Outline",
  opts = function()
    local defaults = require("outline.config").defaults
    local opts = {
      outline_window = {
        position = "right",
        width = 32,
        relative_width = false,
        border = "rounded",
        auto_close = false,
      },
      preview_window = {
        auto_preview = true,
        border = "rounded",
      },
      symbols = {
        icons = {},
        filter = vim.deepcopy(LazyVim.config.kind_filter),
      },
      keymaps = {
        up_and_jump = "<up>",
        down_and_jump = "<down>",
        hover_symbol = "K",
        toggle_preview = "P",
        close = "q",
      },
    }

    for kind, symbol in pairs(defaults.symbols.icons) do
      opts.symbols.icons[kind] = {
        icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
        hl = symbol.hl,
      }
    end

    local ok, catppuccin = pcall(require, "catppuccin.groups.integrations.outline")
    if ok and catppuccin then
      opts = vim.tbl_deep_extend("force", opts, catppuccin.get())
    end

    return opts
  end,

  config = function(_, opts)
    require("outline").setup(opts)

    -- 🪄 Auto-open Outline for certain filetypes
    --  local filetypes = require("config.ftypes.filetypes").code
    --  vim.api.nvim_create_autocmd("BufReadPost", {
    --    pattern = "*",
    --    callback = function()
    --      local ft = vim.bo.filetype
    --      if vim.tbl_contains(filetypes, ft) then
    --        -- open Outline but don’t steal focus
    --        vim.defer_fn(function()
    --          vim.cmd "OutlineOpen"
    --        end, 200)
    --      end
    --    end,
    --  })
  end,
}
