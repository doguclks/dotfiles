local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'vsnip' },
  }, {
    { name = 'calc' },
    { name = 'buffer' },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        vsnip = '[Vsnip]',
        nvim_lua = '[Lua]',
        calc = '[Calc]',
      })[entry.source.name]

      return vim_item
    end
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  }
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  })
})

local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>p', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  client.server_capabilities.semanticTokensProvider = nil
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.config('rust_analyzer', {
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.config('gopls', {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Roslyn C# LSP Server
local has_roslyn, roslyn = pcall(require, "roslyn")
if has_roslyn then
  roslyn.setup({})
end

vim.lsp.config('roslyn', {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Neovim 0.11+ sunucuları etkinleştir
-- gopls / rust_analyzer: Go ve Rust araç zinciri kurulunca listeye geri eklenebilir (config'leri yukarıda duruyor)
vim.lsp.enable({ 'ts_ls', 'lua_ls', 'roslyn' })

require("fidget").setup({})

-- Global LSP & Diagnostic Keymaps (which-key'de görünmesi ve buffer henüz attach olmasa bile erişilebilmesi için)
local map_global = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

map_global('n', 'gd', vim.lsp.buf.definition, "LSP: Go to Definition")
map_global('n', 'gD', vim.lsp.buf.declaration, "LSP: Go to Declaration")
map_global('n', 'gi', vim.lsp.buf.implementation, "LSP: Go to Implementation")
map_global('n', '<leader>ca', vim.lsp.buf.code_action, "LSP: Code Action")
map_global('n', '<leader>rn', vim.lsp.buf.rename, "LSP: Rename")
map_global('n', '<leader>p', function() vim.lsp.buf.format({ async = true }) end, "LSP: Format")
map_global('n', '<leader>e', vim.diagnostic.open_float, "Diagnostic: Open Float")
map_global('n', '[d', vim.diagnostic.goto_prev, "Diagnostic: Prev")
map_global('n', ']d', vim.diagnostic.goto_next, "Diagnostic: Next")
map_global('n', '<leader>q', vim.diagnostic.setloclist, "Diagnostic: Set Loclist")
