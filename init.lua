-- Use dedicated Python 3 provider (created venv with pynvim)
vim.g.python3_host_prog = "/Users/lhr/.local/share/nvim/py3-venv/bin/python"

require("defaults")
require("keymaps")
require("plugins")
require("lsp")
