-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- This code sets up an autocommand in Neovim that triggers when the file type of
-- the current buffer matches "json," "jsonc," or "markdown." When this event occurs,
-- it turns off text concealment by setting the conceallevel option to 0.
-- This could be useful in scenarios where you want to disable text concealment for these specific file types,
-- perhaps for better visibility or to view the raw content of the file.
-- NOTE: The default conceallevel is 3 in LazyVim which is now overriden by this autocommand.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.md" },
  callback = function()
    -- If the current file is a note file created by note_taker.sh, then convert the note to PDF
    if vim.fn.expand("%:t"):match("^note%-.*%.md$") then
      -- convert_md_note_to_pdf.sh is in ~/Dotfiles/bin directory which is symlinked to ~/.config/bin
      -- The script is also exported to PATH in ~/.zshrc
      vim.fn.system("convert_md_note_to_pdf.sh " .. vim.fn.shellescape(vim.fn.expand("%:p")))
    end
  end,
})

-- setlocal textwidth=80 for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})
