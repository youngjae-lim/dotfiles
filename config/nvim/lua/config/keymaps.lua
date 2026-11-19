-- General key mappings. Plugin keys live next to their plugin in lua/plugins/.
--
-- Rules for this setup (see docs/11-neovim.md):
--   * Leader is Space. Groups: b buffer, c code, f find, g git, n notes,
--     q quit/session, s search, u toggle (UI), p plugins.
--   * Never Alt: AeroSpace takes every Alt key first.
--   * Never Ctrl+H/J/K/L: Karabiner turns them into arrow keys.
--   * Inside herdr, Ctrl+B belongs to herdr.
local map = vim.keymap.set

-- Move by screen line on wrapped lines (unless a count is given, e.g. 5j)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })

-- Line start / end
map("n", ";a", "^", { desc = "First non-blank character" })
map("n", ";e", "$", { desc = "End of line" })

-- Windows: arrows move between them, Shift+arrows resize
map("n", "<Left>", "<C-w>h", { desc = "Window left" })
map("n", "<Right>", "<C-w>l", { desc = "Window right" })
map("n", "<Up>", "<C-w>k", { desc = "Window up" })
map("n", "<Down>", "<C-w>j", { desc = "Window down" })
map("n", "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Narrower" })
map("n", "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Wider" })
map("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Shorter" })
map("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Taller" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split below" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split right" })
map("n", "<leader>mx", function()
  require("mini.misc").zoom()
end, { desc = "Maximise / restore window" })

-- Buffers
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", function()
  require("mini.bufremove").delete()
end, { desc = "Delete buffer (keep window)" })
map("n", "<leader>bo", "<cmd>%bdelete|edit#|bdelete#<cr>", { desc = "Delete other buffers" })

-- Save / quit
map({ "n", "x" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>quitall<cr>", { desc = "Quit all" })

-- Editing
map("n", "<Esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Clear search highlight" })
map("x", "<", "<gv", { desc = "Indent left (keep selection)" })
map("x", ">", ">gv", { desc = "Indent right (keep selection)" })

-- Diagnostics (errors and warnings)
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Toggles
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle wrap" })
map("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
map("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- Notes keys (<leader>n…) live in lua/plugins/notes.lua

-- Plugins
map("n", "<leader>pu", function()
  vim.pack.update()
end, { desc = "Update plugins (review, then :write)" })
