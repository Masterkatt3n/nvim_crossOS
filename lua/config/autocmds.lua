vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.sh",
  callback = function()
    vim.opt_local.fileformat = "unix"
  end,
})

-- Fix to tame coloring-madness in .ps1 files
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "powershell_es" then
      vim.lsp.semantic_tokens.enable(false, { bufnr = args.buf })
    end
  end,
})

vim.api.nvim_create_user_command("LspCaps", function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    print "No active LSP clients."
    return
  end

  for _, client in ipairs(clients) do
    print("== " .. client.name .. " ==")
    print(vim.inspect(client.server_capabilities))
  end
end, {})

vim.api.nvim_create_user_command("LspSem", function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    print "No active LSP clients."
    return
  end

  for _, client in ipairs(clients) do
    local sem = client.server_capabilities.semanticTokensProvider
    if sem then
      print(string.format("✅ %s → semanticTokensProvider enabled", client.name))
      print(vim.inspect(sem))
    else
      print(string.format("❌ %s → no semanticTokensProvider", client.name))
    end
  end
end, {})

-- Toggle hard wrapping in the current window
vim.api.nvim_create_user_command("ToggleWrap", function()
  local wrap = vim.wo.wrap

  vim.wo.wrap = not wrap
  vim.wo.linebreak = not wrap
  vim.wo.breakindent = not wrap
  vim.wo.showbreak = wrap and "" or "↪ "

  if wrap then
    vim.notify("Wrap disabled", vim.log.levels.INFO)
  else
    vim.notify("Wrap enabled", vim.log.levels.INFO)
  end
end, {})

-- pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")
--
-- -- --- Force wrap in log/text buffers no matter what ---
-- vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufWinEnter" }, {
--   group = vim.api.nvim_create_augroup("force_wrap_for_logs", { clear = true }),
--   pattern = { "*.log", "log", "text" },
--   callback = function()
--     -- triple fallback: schedule + reapply after short delay
--     vim.schedule(function()
--       vim.defer_fn(function()
--         vim.opt_local.wrap = true
--         vim.opt_local.linebreak = true
--         vim.opt_local.breakindent = true
--         vim.opt_local.showbreak = "↪ "
--       end, 50)
--     end)
--   end,
-- })
