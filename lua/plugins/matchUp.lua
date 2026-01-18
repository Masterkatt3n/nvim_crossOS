-- "~/.config/nvim/lua/plugins/matchUp.lua"
---@type string[]
local ft_code = require("config.ftypes.filetypes").code

---@type LazyPluginSpec
return {
  "andymass/vim-matchup",
  ft = ft_code,
  init = function()
    -- Make paren matches clearer
    vim.api.nvim_set_hl(0, "MatchParen", { bold = true, standout = true })

    vim.g.matchup_matchparen_offscreen = {
      method = "popup",
      show_line = "number",
    }

    vim.g.matchup_matchparen_deferred = 1 -- prevents flicker when blink.pairs autocompletes
    vim.g.matchup_surround_enabled = 1 -- enable enhanced surround
    vim.g.matchup_transmute_enabled = 1 -- cool advanced % movements
    vim.g.matchup_matchpref = { html = { tagnameonly = 1 } }
  end,
}
