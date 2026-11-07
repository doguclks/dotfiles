-- tree-sitter CLI Windows'ta varsayılan olarak MSVC (cl.exe) arar; MSVC yok, scoop'un gcc'si var.
-- Sadece Neovim (ve alt süreçleri) için geçerli.
if vim.fn.has('win32') == 1 and not vim.env.CC and vim.fn.executable('gcc') == 1 then
  vim.env.CC = 'gcc'
end

-- ftplugin/*.lua içindeki vim.treesitter.start() çağrılarının ihtiyaç duyduğu parser'lar.
-- Zaten kurulu olanlar için install() hiçbir şey yapmaz.
require('nvim-treesitter').install({ 'c_sharp', 'css', 'html', 'javascript', 'typescript', 'tsx' })
