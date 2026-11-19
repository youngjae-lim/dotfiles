-- Automatic actions ("autocommands"). See :help autocmd-events.
local group = vim.api.nvim_create_augroup("lean", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Briefly highlight yanked (copied) text
autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reopen a file at the line you were last on
autocmd("BufReadPost", {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Keep splits equal when the terminal is resized
autocmd("VimResized", {
  group = group,
  command = "tabdo wincmd =",
})

-- Show JSON and Markdown as written (no hidden quotes or link syntax)
autocmd("FileType", {
  group = group,
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Markdown: hard-wrap at 80 columns
autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})
