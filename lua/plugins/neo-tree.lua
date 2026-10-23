return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        position = "left",
        width = 30,
      },
      filesystem = {
        follow_current_file = { enabled = true },
        hide_dotfiles = false,
      },
    })

    vim.keymap.set("n", "<leader>e", function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd("Neotree close")
      else
        vim.cmd("Neotree focus")
      end
    end, { desc = "Dosya ağacına odaklan / aç / kapat" })
  end,
}
