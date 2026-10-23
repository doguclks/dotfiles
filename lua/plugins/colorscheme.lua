return {
  "catppuccin/nvim",
  name = "catppuccin",
  commit = "426dbebe06b5c69fd846ceb17b42e12f890aedf1",
  priority = 1000,
  opts = {
    flavour = "mocha",
    transparent_background = true,
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
      },
      telescope = { enabled = true },
      neotree = true,
      bufferline = true,
      which_key = true,
      gitsigns = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")

    -- Ensure full transparency for all UI elements
    local transparent_groups = {
      "Normal", "NormalNC", "NormalFloat", "FloatBorder",
      "SignColumn", "FoldColumn", "StatusLine", "StatusLineNC",
      "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer", "NeoTreeWinSeparator",
      "BufferLineFill", "BufferLineBackground",
      "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal",
      "WinSeparator", "EndOfBuffer",
      "LineNr", "CursorLineNr", "NormalSB",
    }
    for _, group in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    end
  end,
}
