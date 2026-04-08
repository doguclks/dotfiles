return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup()

    wk.add({
      { "<leader>f",  group = "Telescope" },
      { "<leader>ff", desc = "Dosya ara" },
      { "<leader>fg", desc = "İçerik ara (grep)" },
      { "<leader>fb", desc = "Buffer'lar" },
      { "<leader>fh", desc = "Help" },

      { "<leader>e",  desc = "Dosya gezgini (Neo-tree)" },

      { "<leader>r",  group = "LSP" },
      { "<leader>rn", desc = "Yeniden adlandır" },
      { "<leader>ca", desc = "Code action" },
      { "<leader>d",  desc = "Diagnostic detay" },
      { "gd",         desc = "Tanıma git" },
      { "gr",         desc = "Referanslar" },
      { "K",          desc = "Hover dokümantasyon" },
    })
  end,
}
