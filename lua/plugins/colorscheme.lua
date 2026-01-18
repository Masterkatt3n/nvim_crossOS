-- "~/.config/nvim/lua/plugins/colorscheme.lua"
return {
  "navarasu/onedark.nvim",
  -- "tiagovla/tokyodark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("onedark").setup {
      style = "darker",
      colors = {
        bg0 = "#11121d", --Optional. Same background "black" as tokyodark
      },
    }
    require("onedark").load()
  end,
}
--     vim.cmd.colorscheme "tokyodark"
--   end,
-- }
