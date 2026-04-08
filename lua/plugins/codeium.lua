return {
  "Exafunction/codeium.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("codeium").setup({
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
      },
    })

    -- Disable codeium on unnamed buffers to prevent "path is empty" errors
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.api.nvim_buf_get_name(0) == "" then
          vim.b.codeium_enabled = false
        end
      end,
    })
  end,
}
