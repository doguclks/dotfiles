local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

which_key.setup({
  preset = "modern",
  spec = {
    { "<leader>f", group = "find / telescope" },
    { "<leader>g", group = "git" },
    { "<leader>d", group = "diff / diagnostics" },
    { "<leader>y", group = "yank / AI" },
    { "<leader>h", group = "hunks / highlight" },
  },
})
