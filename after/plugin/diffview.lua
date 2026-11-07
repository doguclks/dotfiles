local status_ok, diffview = pcall(require, "diffview")
if not status_ok then
  return
end

diffview.setup({})

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>dv', '<cmd>DiffviewOpen<CR>', vim.tbl_extend('force', opts, { desc = "Git: Diffview Open" }))
vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<CR>', vim.tbl_extend('force', opts, { desc = "Git: Diffview Close" }))
vim.keymap.set('n', '<leader>dh', '<cmd>DiffviewFileHistory %<CR>', vim.tbl_extend('force', opts, { desc = "Git: File History (Current File)" }))
vim.keymap.set('n', '<leader>df', '<cmd>DiffviewFileHistory<CR>', vim.tbl_extend('force', opts, { desc = "Git: File History (Branch)" }))
