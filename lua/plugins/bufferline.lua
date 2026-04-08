return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup()

    vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Sonraki buffer" })
    vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Önceki buffer" })
    vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { desc = "Buffer'ı kapat" })
    vim.keymap.set("n", "<leader>X", ":bdelete!<CR>", { desc = "Buffer'ı kaydetmeden kapat" })
  end,
}
