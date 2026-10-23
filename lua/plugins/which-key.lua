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

      { "<leader>g",  group = "Git" },
      { "<leader>gd", desc = "Yan yana diff" },
      { "<leader>gs", desc = "Git durumu (Status)" },
      { "<leader>gp", desc = "Hunk önizlemesi (Preview)" },
      { "<leader>ga", desc = "Hunk sahneye al (Stage)" },
      { "<leader>gu", desc = "Sahneye almayı geri al (Undo stage)" },
      { "<leader>gr", desc = "Hunk sıfırla (Reset)" },
      { "<leader>gR", desc = "Tüm dosyayı sıfırla" },
      { "<leader>gb", desc = "Satır blame penceresi" },
      { "<leader>gB", desc = "Satır içi blame aç/kapat" },
      { "<leader>gD", desc = "Diff önizlemesi" },

      { "<leader>h",  group = "Git Hunk" },
      { "<leader>hp", desc = "Hunk önizlemesi" },
      { "<leader>hs", desc = "Hunk sahneye al" },
      { "<leader>hu", desc = "Sahneye almayı geri al" },
      { "<leader>hr", desc = "Hunk sıfırla" },
      { "<leader>hS", desc = "Tüm dosyayı sahneye al" },
      { "<leader>hR", desc = "Tüm dosyayı sıfırla" },
      { "<leader>hb", desc = "Satır blame penceresi" },
      { "<leader>hd", desc = "Diff önizlemesi" },

      { "<leader>e",  desc = "Dosya gezgini (Neo-tree)" },
      { "<leader>x",  desc = "Sekmeyi (Buffer) kapat" },
      { "<leader>X",  desc = "Sekmeyi kaydetmeden kapat" },

      { "<leader>y",  group = "AI Kopyala (Yank)" },
      { "<leader>yl", desc = "Dosya yolu + satır(lar)" },
      { "<leader>yc", desc = "Kod bloğu + dosya referansı" },
      { "<leader>yf", desc = "Fonksiyon/metot adı + dosya" },

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
