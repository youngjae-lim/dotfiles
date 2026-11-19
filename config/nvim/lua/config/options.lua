-- Editor options. See :help option-list for any of these.
local opt = vim.opt

-- Lines and columns
opt.number = true -- line numbers
opt.relativenumber = false
opt.cursorline = true -- highlight the current line
opt.signcolumn = "yes" -- always show the sign column, so text doesn't shift
opt.scrolloff = 4 -- keep 4 lines visible above/below the cursor
opt.wrap = true -- wrap long lines...
opt.linebreak = true -- ...at word boundaries
opt.winbar = "%=%m %f" -- top-right of each window: modified flag + file path

-- Indentation
opt.expandtab = true -- spaces, not tabs
opt.shiftwidth = 4 -- size of an indent
opt.tabstop = 4
opt.shiftround = true -- round indents to a multiple of shiftwidth

-- Searching
opt.ignorecase = true -- case-insensitive...
opt.smartcase = true -- ...unless the search has a capital letter

-- Windows and the screen
opt.splitright = true -- new vertical splits open to the right
opt.splitbelow = true -- new horizontal splits open below
opt.laststatus = 3 -- one statusline for the whole screen
opt.showmode = false -- the statusline already shows the mode
opt.pumheight = 10 -- at most 10 items in popup menus
opt.fillchars = { eob = " " } -- no ~ after the end of the buffer
opt.mouse = "a"

-- Behaviour
opt.undofile = true -- keep undo history after closing a file
opt.confirm = true -- ask to save instead of refusing to quit
opt.updatetime = 200 -- faster CursorHold (diagnostic popups, git signs)
opt.timeoutlen = 300 -- how long to wait for the next key of a mapping
opt.iskeyword:append("-") -- treat dash-separated-words as one word

-- The system clipboard. Deferred: looking up the clipboard tool costs a few ms.
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

-- Plugins written in Node, Perl, Python or Ruby ("remote plugins") aren't used
-- here. Switching their hosts off skips a search at startup and silences
-- :checkhealth's warnings about them.
for _, lang in ipairs({ "node", "perl", "python3", "ruby" }) do
  vim.g["loaded_" .. lang .. "_provider"] = 0
end
