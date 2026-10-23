-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Python 3 provider (Windows / macOS / Linux uyumlu)
if vim.fn.has("win32") == 1 then
  local python_path = vim.fs.joinpath(vim.env.USERPROFILE or "", "scoop", "apps", "python", "current", "python.exe")
  if vim.fn.filereadable(python_path) == 1 then
    vim.g.python3_host_prog = python_path
  end
  -- Ensure Git usr/bin is in PATH on Windows for echo, unzip, gzip
  local git_usr_bin = "C:\\Program Files\\Git\\usr\\bin"
  if vim.fn.isdirectory(git_usr_bin) == 1 and not string.find(vim.env.PATH, git_usr_bin, 1, true) then
    vim.env.PATH = vim.env.PATH .. ";" .. git_usr_bin
  end
else
  -- macOS / Linux: Homebrew veya sistem python3 tespiti
  local brew_python_arm = "/opt/homebrew/bin/python3"
  local brew_python_intel = "/usr/local/bin/python3"
  if vim.fn.filereadable(brew_python_arm) == 1 then
    vim.g.python3_host_prog = brew_python_arm
  elseif vim.fn.filereadable(brew_python_intel) == 1 then
    vim.g.python3_host_prog = brew_python_intel
  elseif vim.fn.executable("python3") == 1 then
    vim.g.python3_host_prog = vim.fn.exepath("python3")
  end
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy.lazy")
