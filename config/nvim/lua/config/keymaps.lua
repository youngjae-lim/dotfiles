-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Move window
-- NOTE: On my mac, <C-h/j/k/l> is mapped to arrow keys using Karabiner.
keymap.set("n", "<left>", "<C-w>h")
keymap.set("n", "<right>", "<C-w>l")
keymap.set("n", "<up>", "<C-w>k")
keymap.set("n", "<down>", "<C-w>j")


-- Resize window using :vertical and :resize
-- Window is the one that is currently in focus
keymap.set("n", "<S-left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<S-right>", ":vertical resize +2<CR>", opts)
keymap.set("n", "<S-down>", ":resize -2<CR>", opts)
keymap.set("n", "<S-up>", ":resize +2<CR>", opts)

-- Next, Previous buffer
-- NOTE: Not working
-- keymap.set("n", "<tab>", ":tabnext<Return>", opts)
-- keymap.set("n", "<S-tab>", ":tabprev<Return>", opts)

-- Opens the previous picker
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume" }
)

-- Run convert_md_note_to_ppt.sh when <leader>np is pressed
vim.keymap.set("n", "<leader>np", function()
  vim.fn.system("notes ppt " .. vim.fn.shellescape(vim.fn.expand("%:p")))
end, { noremap = true, silent = true, desc = "Convert markdown note to ppt" })

-- Debug go test
vim.keymap.set("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { noremap = true, silent = true, desc = "Debug go test" })

-- Debug last go test
-- NOTE: Understand this better
vim.keymap.set("n", "<leader>dgl", function()
  require("dap-go").debug_last()
end, { noremap = true, silent = true, desc = "Debug last go test" })

-- Debug python test
-- NOTE: Understand this better
vim.keymap.set("n", "<leader>dpy", function()
  require("dap-python").test_method()
end, { noremap = true, silent = true, desc = "Debug python test" })

-- Go to the first non-blank character of the line
vim.keymap.set(
  "n",
  ";a",
  "^",
  { noremap = true, silent = true, desc = "Go to the first non-blank character of the line" }
)

-- Go to the end of the line
vim.keymap.set("n", ";e", "$", { noremap = true, silent = true, desc = "Go to the end of the line" })

-- toggleterm keymaps
-- toggle terminal
-- vim.keymap.set("n", "<leader>tt", function()
--   require("toggleterm").toggle()
-- end, { noremap = true, silent = true, desc = "Toggle terminal" })

-- open terminal
-- vim.keymap.set(
--   "n",
--   "<leader>to",
--   ":ToggleTerm direction=vertical <CR>",
--   { noremap = true, silent = true, desc = "Open terminal" }
-- )

-- close terminal
-- vim.keymap.set("n", "<leader>tc", ":ToggleTerm ", { noremap = true, silent = true, desc = "Close terminal" })
