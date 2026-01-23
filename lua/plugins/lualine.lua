-- "\.config\nvim\lua\plugins\lualine.lua"
---@type LazyPluginSpec
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "tiagovla/tokyodark.nvim" },
  opts = function()
    local function current_line_diagnostic()
      local line = vim.api.nvim_win_get_cursor(0)[1] - 1
      local diag = vim.diagnostic.get(0, { lnum = line })
      if #diag == 0 then
        return ""
      end
      return "⚠️ " .. diag[1].message:gsub("\n", " "):sub(1, 80)
    end
    local function lsp_status()
      local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
      if #buf_clients == 0 then
        return "LSP: none"
      end
      local names = {}
      for _, c in pairs(buf_clients) do
        table.insert(names, c.name)
      end
      return " " .. table.concat(names, ", ")
    end
    local function clock()
      return os.date("%H:%M:%S")
    end
    return {
      options = { theme = "tokyodark" },
      sections = {
        lualine_a = { clock, "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { lsp_status, current_line_diagnostic },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }
  end,
}
