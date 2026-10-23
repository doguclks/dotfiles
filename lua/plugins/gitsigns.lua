return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 500,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Hunk Gezinme (Navigation)
      local function next_hunk()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end

      local function prev_hunk()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end

      map("n", "]c", next_hunk, { expr = true, desc = "Sonraki Git Değişikliği (Hunk)" })
      map("n", "[c", prev_hunk, { expr = true, desc = "Önceki Git Değişikliği (Hunk)" })
      map("n", "]h", next_hunk, { expr = true, desc = "Sonraki Git Değişikliği (Hunk)" })
      map("n", "[h", prev_hunk, { expr = true, desc = "Önceki Git Değişikliği (Hunk)" })

      -- Hunk Eylemleri (<leader>h ve <leader>g)
      map("n", "<leader>hs", gs.stage_hunk, { desc = "Hunk'ı Sahneye Al (Stage)" })
      map("n", "<leader>hr", gs.reset_hunk, { desc = "Hunk'ı Sıfırla (Reset)" })
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Seçili Alanı Sahneye Al" })
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Seçili Alanı Sıfırla" })
      map("n", "<leader>hS", gs.stage_buffer, { desc = "Tüm Dosyayı Sahneye Al" })
      map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Sahneye Almayı Geri Al" })
      map("n", "<leader>hR", gs.reset_buffer, { desc = "Tüm Dosya Değişikliklerini Sıfırla" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Hunk Önizlemesi (Preview)" })
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, { desc = "Satır Blame Penceresi" })
      map("n", "<leader>hd", gs.diffthis, { desc = "Diff Önizlemesi" })

      -- Git Menüsü Altında Hızlı Kısayollar (<leader>g...)
      map("n", "<leader>gp", gs.preview_hunk, { desc = "Hunk Önizlemesi (Preview)" })
      map("n", "<leader>ga", gs.stage_hunk, { desc = "Hunk Sahneye Al (Stage)" })
      map("v", "<leader>ga", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Seçili Alanı Sahneye Al" })
      map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Sahneye Almayı Geri Al" })
      map("n", "<leader>gr", gs.reset_hunk, { desc = "Hunk Sıfırla (Reset)" })
      map("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Seçili Alanı Sıfırla" })
      map("n", "<leader>gR", gs.reset_buffer, { desc = "Tüm Dosyayı Sıfırla" })
      map("n", "<leader>gb", function()
        gs.blame_line({ full = true })
      end, { desc = "Satır Blame Penceresi" })
      map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Satır İçi Blame Aç/Kapat" })
      map("n", "<leader>gD", gs.diffthis, { desc = "Git Diff Karşılaştır" })

      -- Text Object: ih (ör. vic veya dih ile hunk seçimi/silme)
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git Hunk Seç" })
    end,
  },
}
