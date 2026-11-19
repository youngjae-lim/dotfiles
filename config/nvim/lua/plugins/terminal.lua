-- A terminal at the bottom that you can show and hide.
--   <leader>tt   show / hide it (it's the same shell each time, so a running
--                command keeps going while it's hidden)
--   Esc Esc      inside it: back to normal Neovim keys (scroll, copy, move
--                to another window). A single Esc still goes to the shell.
-- Type `exit` in the shell to close it for good; the next <leader>tt starts
-- a fresh one. For long-running things (dev servers), a herdr split is better.
local term = { buf = nil, win = nil }

local function open_window()
  vim.cmd("botright split")
  vim.api.nvim_win_set_height(0, math.max(8, math.floor(vim.o.lines * 0.3)))
  term.win = vim.api.nvim_get_current_win()
  vim.wo[term.win].number = false
  vim.wo[term.win].signcolumn = "no"
  vim.wo[term.win].winfixheight = true
end

local function start_shell()
  vim.cmd.terminal()
  term.buf = vim.api.nvim_get_current_buf()
  vim.bo[term.buf].buflisted = false -- keep it out of Tab / Shift+Tab
  -- Only this terminal gets Esc Esc, so lazygit and other tools keep their Esc
  vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { buffer = term.buf, desc = "Leave terminal mode" })
end

local function toggle()
  if term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_hide(term.win)
    term.win = nil
    return
  end
  open_window()
  if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    vim.api.nvim_win_set_buf(term.win, term.buf)
  else
    start_shell()
  end
  vim.cmd.startinsert()
end

vim.keymap.set("n", "<leader>tt", toggle, { desc = "Terminal (toggle)" })
