-- Sessions (mini.sessions): reopen a project's windows and files later.
-- One session per project folder, saved automatically when you quit.
--   <leader>qs   restore this folder's session
--   <leader>qS   pick any saved session
--   <leader>qd   don't save a session when quitting this time
local dir = vim.fn.stdpath("state") .. "/sessions"
vim.fn.mkdir(dir, "p")

require("mini.sessions").setup({ directory = dir, file = "", autoread = false, autowrite = false })

-- Session name for the current folder, e.g. %Users%you%Projects%app.vim
local function name()
  return (vim.fn.getcwd():gsub("[/\\:]", "%%")) .. ".vim"
end

-- Is there anything worth saving? Skip git commit messages and empty starts.
local function worth_saving()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.bo[buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" then
      return false
    end
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
      return true
    end
  end
  return false
end

local skip = false
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if not skip and worth_saving() then
      pcall(MiniSessions.write, name(), { force = true, verbose = false })
    end
  end,
})

vim.keymap.set("n", "<leader>qs", function()
  if not pcall(MiniSessions.read, name()) then
    vim.notify("No saved session for this folder yet.")
  end
end, { desc = "Restore session for this folder" })
vim.keymap.set("n", "<leader>qS", function()
  MiniSessions.select("read")
end, { desc = "Pick a session" })
vim.keymap.set("n", "<leader>qd", function()
  skip = true
  vim.notify("This session won't be saved when you quit.")
end, { desc = "Don't save session on quit" })
