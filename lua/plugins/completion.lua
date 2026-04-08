return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = { "Exafunction/codeium.nvim" },
  opts = {
    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "codeium" },
      providers = {
        codeium = {
          name = "Codeium",
          module = "codeium.blink",
          async = true,
          enabled = function()
            return vim.api.nvim_buf_get_name(0) ~= ""
          end,
        },
      },
    },
  },
}
