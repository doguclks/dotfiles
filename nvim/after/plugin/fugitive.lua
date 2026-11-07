local opts = { noremap = true, silent = true }

-- Fugitive Git Status: Staged, Unstaged ve Untracked dosyaları gösterir
-- Bu ekranda:
--   's' -> stage
--   'u' -> unstage
--   '=' -> inline diff toggle
--   'cc' -> commit
vim.keymap.set('n', '<leader>gs', '<cmd>Git<CR>', vim.tbl_extend('force', opts, { desc = "Git: Status (Fugitive)" }))
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<CR>', vim.tbl_extend('force', opts, { desc = "Git: Blame" }))
vim.keymap.set('n', '<leader>gp', '<cmd>Git push<CR>', vim.tbl_extend('force', opts, { desc = "Git: Push" }))
vim.keymap.set('n', '<leader>gP', '<cmd>Git pull<CR>', vim.tbl_extend('force', opts, { desc = "Git: Pull" }))
