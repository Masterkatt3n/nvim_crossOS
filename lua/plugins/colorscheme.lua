-- "~/.config/nvim/lua/plugins/colorscheme.lua"

return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,

  config = function()
    local onedark = require("onedark")

    onedark.setup({
      style = "darker", -- default style on startup

      colors = {
        bg0 = "#11121d", -- override base background (main editor background)
      },

      highlights = {}, -- override highlight groups (advanced usage)

      transparent = false, -- disable background (true = transparent background)
      term_colors = true, -- sync terminal colors with theme (useful for :terminal)
      ending_tildes = false, -- hide ~ at end of buffer
      cmp_itemkind_reverse = false, -- invert icon/text highlight in nvim-cmp menu

      -- Disable built-in toggle (we handle it via custom module)
      toggle_style_key = nil,

      -- Order used when cycling themes manually
      toggle_style_list = {
        "dark",
        "darker",
        "cool",
        "deep",
        "warm",
        "warmer",
        "light",
      },

      -- Styling for syntax groups
      -- options: "italic", "bold", "underline", "none"
      code_style = {
        comments = "none",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      -- Lualine integration (only affects background blending)
      lualine = {
        transparent = false, -- match statusline background with theme
      },

      -- Diagnostics (LSP, lint, etc.)
      diagnostics = {
        darker = true, -- use slightly dimmer colors for diagnostics
        undercurl = true, -- use wavy underline instead of straight underline
        background = true, -- add subtle background to virtual text
      },
    })

    onedark.load() -- apply colorscheme

    -- Custom toggle (handled by your tracker module)
    vim.keymap.set("n", "<leader>ts", function()
      require("config.tracker.oneDhelper").next()
    end, { desc = "Toggle theme" })
  end,
}
