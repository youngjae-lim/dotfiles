-- Lean Neovim config: Neovim 0.12+ built-ins plus a short list of plugins.
-- No plugin manager besides Neovim's own vim.pack.
-- How it fits together, and how to change it: ~/Dotfiles/docs/11-neovim.md

-- Cache compiled Lua modules: the cheapest startup win there is.
vim.loader.enable()

-- Leader keys must be set before any mapping is made.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.pack") -- installs/registers every plugin (the only place plugins are listed)
require("config.keymaps")
require("config.autocmds")

-- One file per area, in lua/plugins/. Order matters only for "completion"
-- before "lsp" (language servers need blink.cmp's capabilities).
-- A broken file reports an error instead of taking the whole editor down.
for _, name in ipairs({
  "ui",
  "treesitter",
  "completion",
  "lsp",
  "editing",
  "git",
  "format",
  "lint",
  "finder",
  "tree",
  "sessions",
}) do
  local ok, err = pcall(require, "plugins." .. name)
  if not ok then
    vim.notify(("plugins/%s.lua failed: %s"):format(name, err), vim.log.levels.ERROR)
  end
end
