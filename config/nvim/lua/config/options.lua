-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Display a full file path to the upper right corner of edtior along with a modified flag
opt.winbar = "%=%m %f" -- %m = modified flag, %f = full file path
opt.iskeyword:append({ "-" }) -- treat dash separated words as a word text object"
opt.shiftwidth = 4 -- Size of an indent
opt.relativenumber = false -- turn off relative numbers
opt.wrap = true -- Wrap lines
-- opt.textwidth = 80 -- Maximum width of text NOTE: this is not working.
-- opt.colorcolumn = "80" -- Line length marker at 80 columns
-- vim.filetype.add({ extension = { templ = "templ" } })
