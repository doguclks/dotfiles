local omnisharp_bin = "OmniSharp"
local bin_name = vim.fn.has("win32") == 1 and "OmniSharp.cmd" or "OmniSharp"
local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", bin_name)
if vim.fn.filereadable(mason_bin) == 1 then
  omnisharp_bin = mason_bin
end

return {
  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  filetypes = { "cs", "vb" },
  root_markers = { "*.sln", "*.csproj", ".git" },
  settings = {
    omnisharp = {
      enableRoslynAnalyzers = true,
      enableEditorConfigSupport = true,
      organizeImportsOnFormat = true,
    },
  },
}
