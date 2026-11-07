require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
    live_grep_args = {
      auto_quoting = true,
    },
  },
  defaults = {
    preview = false,
    borderchars = { "┈", "┊", "┈", "┊", "┌", "┐", "┘", "└" },
    prompt_prefix = "  ",
    selection_caret = "» ",
  },
})

require('telescope').load_extension('live_grep_args')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('ui-select')

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', vim.tbl_extend('force', opts, { desc = "Find: Files" }))
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep_args<CR>', vim.tbl_extend('force', opts, { desc = "Find: Live Grep" }))
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', vim.tbl_extend('force', opts, { desc = "Find: Buffers" }))
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', vim.tbl_extend('force', opts, { desc = "Find: Help Tags" }))
vim.keymap.set('n', '<leader>fx', '<cmd>Telescope file_browser<CR>', vim.tbl_extend('force', opts, { desc = "Find: File Browser" }))
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope git_status<CR>', vim.tbl_extend('force', opts, { desc = "Find: Git Status" }))
vim.keymap.set('n', '<leader>gS', '<cmd>Telescope git_status<CR>', vim.tbl_extend('force', opts, { desc = "Git: Status (Telescope)" }))

vim.api.nvim_set_keymap('v', '<leader>ff', '"hy\\ff<c-r>h', {})
vim.api.nvim_set_keymap('v', '<leader>fg', '"hy\\fg<c-r>h', {})
vim.api.nvim_set_keymap('v', '<leader>r', '"hy:%s/<c-r>h//g<left><left>', { noremap = true })
