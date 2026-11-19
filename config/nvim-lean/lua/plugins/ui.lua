-- Look and feel: colour scheme, icons, statusline, buffer tabs, notifications,
-- key hints. All from mini.nvim except the colour schemes.

-- Colour scheme: gruvbox by default; <leader>uC picks another (live preview)
-- and the choice is remembered in ~/.local/state/nvim-lean/colorscheme.
local theme_file = vim.fn.stdpath("state") .. "/colorscheme"

local function saved_theme()
  local f = io.open(theme_file, "r")
  if not f then
    return nil
  end
  local name = f:read("*l")
  f:close()
  return name
end

local themes = require("config.themes")
local theme = saved_theme() or "gruvbox"
themes.load_for(theme)
if not pcall(vim.cmd.colorscheme, theme) then
  themes.load_for("gruvbox")
  pcall(vim.cmd.colorscheme, "gruvbox")
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(ev)
    local f = io.open(theme_file, "w")
    if f then
      f:write(ev.match)
      f:close()
    end
  end,
})

-- Icons, also served to plugins that expect nvim-web-devicons (nvim-tree, fzf-lua)
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.statusline").setup() -- bottom line: mode, git, diagnostics, file, position
require("mini.tabline").setup() -- top line: open buffers (Tab / Shift+Tab to switch)
require("mini.bufremove").setup() -- <leader>bd closes a buffer but keeps the window
require("mini.misc").setup() -- <leader>mx zoom

-- Notifications in the corner instead of the message line
require("mini.notify").setup()
vim.notify = MiniNotify.make_notify()

-- Key hints: press <leader> (or g, z, [, ], ", ', <C-w>) and wait to see what's next.
-- Set up after the first screen is drawn.
vim.schedule(function()
  local clue = require("mini.clue")
  clue.setup({
    window = { delay = 300 },
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" },
    },
    clues = {
      clue.gen_clues.square_brackets(),
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
      { mode = "n", keys = "<Leader>b", desc = "+buffer" },
      { mode = "n", keys = "<Leader>c", desc = "+code" },
      { mode = "n", keys = "<Leader>f", desc = "+find" },
      { mode = "n", keys = "<Leader>g", desc = "+git" },
      { mode = "n", keys = "<Leader>n", desc = "+notes" },
      { mode = "n", keys = "<Leader>p", desc = "+plugins" },
      { mode = "n", keys = "<Leader>q", desc = "+quit/session" },
      { mode = "n", keys = "<Leader>s", desc = "+search" },
      { mode = "n", keys = "<Leader>u", desc = "+toggle" },
    },
  })
end)
