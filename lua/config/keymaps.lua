-- ~/.config/nvim/lua/config/keymaps.lua
vim.g.mapleader = " "

local function map(mode, lhs, rhs, opts)
  opts = opts or { noremap = true, silent = true }
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Clipboard
map("v", "<C-c>", '"+y')
vim.keymap.set("i", "<C-v>", function()
  local old = vim.opt.formatoptions:get()
  vim.opt.formatoptions:remove({ "c", "r", "o" })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-r>+", true, true, true), "n", false)
  vim.opt.formatoptions = old
end, { desc = "Paste without comment continuation" })

-- Manual lint and formatting
vim.keymap.set("n", "<leader>lf", function()
  require("conform").format({ async = true })
end, { desc = "Format current file" })

vim.keymap.set("n", "<leader>ll", function()
  require("lint").try_lint()
end, { desc = "Lint current file" })

-- Save / quit
map("n", "<leader>w", "<CMD>update<CR>")
map("n", "<leader>q", "<CMD>q<CR>")

-- Exit insert mode
map("i", "jk", "<ESC>")

-- Windows
-- Open a new vertical split with a copy of the current file (independent buffer)
map(
  "n",
  "<leader>o",
  "<CMD>vsplit | b# | enew | read # | setlocal buftype= | setlocal bufhidden= | setlocal buflisted<CR>",
  { desc = "New vertical split (file copy)" }
)

-- Open a new horizontal split with a copy of the current file (independent buffer)
map(
  "n",
  "<leader>p",
  "<CMD>split | b# | enew | read # | setlocal buftype= | setlocal bufhidden= | setlocal buflisted<CR>",
  { desc = "New horizontal split (file copy)" }
)

-- Reference window: open the same file in readonly mode
map("n", "<leader>rf", "<CMD>vsplit | setlocal readonly<CR>", { desc = "Reference file (readonly)" })

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

-- Scroll faster
map({ "n", "v" }, "K", "5k", { desc = "Up faster" })
map({ "n", "v" }, "J", "5j", { desc = "Down faster" })
