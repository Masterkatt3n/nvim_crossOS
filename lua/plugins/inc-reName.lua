-- "~/.config/nvim/lua/plugins/inc-reName.lua"
return {
  require("inc_rename").setup {
    cmd_name = "IncRename",
    hl_group = "Substitute",
    preview_empty_name = false,
    show_message = true,
    save_in_cmdline_history = true,
    input_buffer_type = snacks,
    post_hook = nil,
  },
}
