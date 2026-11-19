-- Sidebars, both on the right and loaded on first use:
--   <leader>e    file tree (nvim-tree). Inside it: Enter open, a add, d delete,
--                r rename, H show/hide dotfiles, g? all keys
--   <leader>cs   symbols outline of the current file (outline.nvim)
local defer = require("config.defer")

local tree = defer.once(function()
  defer.packadd("nvim-tree.lua")
  require("nvim-tree").setup({
    hijack_netrw = false, -- leave `nvim .` and :Explore to Neovim's own browser
    disable_netrw = false,
    view = { side = "right", width = 30 },
    filters = { dotfiles = false, git_ignored = false }, -- show everything
    update_focused_file = { enable = true }, -- highlight the file you're editing
    renderer = { group_empty = true }, -- show a/b/c as one line when a and b are empty
  })
end)

vim.keymap.set("n", "<leader>e", function()
  tree()
  require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
end, { desc = "File tree" })

local outline = defer.once(function()
  defer.packadd("outline.nvim")
  require("outline").setup({ outline_window = { position = "right", width = 25 } })
end)

vim.keymap.set("n", "<leader>cs", function()
  outline()
  vim.cmd("Outline")
end, { desc = "Symbols outline" })
