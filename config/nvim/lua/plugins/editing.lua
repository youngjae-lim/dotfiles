-- Editing helpers from mini.nvim.

-- Surround, with vim-surround's keys:
--   ys{motion}{char}  add       e.g. ysiw" wraps a word in quotes, yss) a whole line
--   ds{char}          delete    e.g. ds" removes the quotes around the cursor
--   cs{old}{new}      change    e.g. cs"' turns "x" into 'x'
--   S{char}           in Visual mode: surround the selection
require("mini.surround").setup({
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
    suffix_last = "",
    suffix_next = "",
  },
  search_method = "cover_or_next",
})
vim.keymap.del("x", "ys")
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true, desc = "Surround selection" })
vim.keymap.set("n", "yss", "ys_", { remap = true, desc = "Surround line" })

-- More text objects: a/i + ( [ { " ' ` , f (function call), a (argument), t (tag)...
-- e.g. dif deletes inside a function call's parentheses, cia changes an argument.
require("mini.ai").setup()

-- Auto-close brackets and quotes, from the first time you type
require("config.defer").on("InsertEnter", function()
  require("mini.pairs").setup()
end)
