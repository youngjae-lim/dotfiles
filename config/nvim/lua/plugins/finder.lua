-- Fuzzy finder (fzf-lua): files, text, symbols, git, help, colour schemes.
-- Loaded the first time you use one of these keys. Inside any picker:
-- type to filter, Enter opens, Ctrl+V / Ctrl+X open in a split, Esc closes.
local defer = require("config.defer")

local setup = defer.once(function()
  defer.packadd("fzf-lua")
  local fzf = require("fzf-lua")
  fzf.setup({
    fzf_colors = true, -- colours from the Neovim theme
    -- fzf-lua draws its own window; don't let the shell's picker style
    -- (FZF_DEFAULT_OPTS in zsh env.zsh) add boxes inside it
    fzf_opts = { ["--style"] = "default", ["--border"] = "none", ["--height"] = "100%" },
  })
  fzf.register_ui_select() -- code actions and other choices use fzf-lua too
end)

-- Make a key handler that runs one fzf-lua picker
local function pick(name, opts)
  return function()
    setup()
    require("fzf-lua")[name](opts or {})
  end
end

local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { desc = desc })
end

-- Find
map("<leader><space>", pick("files"), "Find files")
map("<leader>ff", pick("files"), "Find files")
map("<leader>fr", pick("oldfiles"), "Recent files")
map("<leader>fb", pick("buffers"), "Open buffers")
map("<leader>fc", pick("files", { cwd = vim.fn.stdpath("config") }), "Neovim config files")

-- Search
map("<leader>/", pick("live_grep"), "Search text in project")
map("<leader>sg", pick("live_grep"), "Search text in project")
map("<leader>sw", pick("grep_cword"), "Search word under cursor")
map("<leader>ss", pick("lsp_document_symbols"), "Symbols in file")
map("<leader>sS", pick("lsp_live_workspace_symbols"), "Symbols in project")
map("<leader>sd", pick("diagnostics_document"), "Diagnostics in file")
map("<leader>sD", pick("diagnostics_workspace"), "Diagnostics in project")
map("<leader>sh", pick("helptags"), "Help pages")
map("<leader>sk", pick("keymaps"), "Key mappings")
map("<leader>sx", pick("resume"), "Resume last picker")

-- Git
map("<leader>gs", pick("git_status"), "Git status")
map("<leader>gc", pick("git_commits"), "Git log")

-- Colour scheme, with live preview (the choice is remembered: ui.lua)
map("<leader>uC", function()
  require("config.themes").load_all() -- so the picker lists every installed theme
  pick("colorschemes")()
end, "Colour scheme")

-- Other files (e.g. plugins/notes.lua) build their own pickers with this
return { pick = pick }
