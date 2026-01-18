-- ~/.config/nvim/lua/config/options.lua
local is_win = vim.fn.has "win32" == 1

vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- vim.lsp.log.set_level(vim.log.levels.ERROR)
-- keep or, if your build supports it:
-- vim.lsp.set_log_level "OFF"

-- vim.opt.display:append("msgsep") -- keep lines in buffers within visible area

local o = vim.opt

-- Line numbering
o.number = true
o.relativenumber = true

-- Tabs and indentation
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.autoindent = true

-- Wrapping and line handling
o.wrap = true -- Wrap long lines at window edge
o.linebreak = true
o.breakindent = true -- Keep indent on wrapped lines
o.showbreak = "↪ " -- Prefix for wrapped lines

-- Cursor and highlighting
o.cursorline = true
o.showmatch = true

-- Clipboard
o.clipboard = "unnamedplus"

-- Appearance
o.termguicolors = true
o.syntax = "on"
o.title = true
o.encoding = "utf-8"

-- Searching / completion
o.completeopt = "menuone,noinsert,noselect"
o.wildmenu = true
o.wildmode = "longest:full"
o.wildoptions = { "pum" }

-- Windows / splits
o.splitright = true
o.splitbelow = true
o.hidden = true

-- Command feedback
o.showcmd = true
o.ruler = true
o.inccommand = "split"

-- Performance
o.ttimeoutlen = is_win and 0 or 25
o.updatetime = 300

-- Shell
if is_win then
  o.shell = "pwsh.exe"
  o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command $PSStyle.OutputRendering = 'PlainText';"
  o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  o.shellquote = ""
  o.shellxquote = ""
end
-- o.shell = "cmd.exe"
-- o.shellcmdflag = "/s /c"
-- o.shellquote = '"'
-- o.shellxquote = '"'
