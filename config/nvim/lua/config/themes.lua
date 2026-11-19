-- Colour schemes are installed but not loaded at startup: only the one you
-- use is loaded, and the rest when you open the picker (<leader>uC).
-- That keeps startup lean, and an unused theme can't affect anything.
local defer = require("config.defer")
local M = {}

-- Colour scheme name prefix -> plugin (as named in config/pack.lua)
M.plugins = {
  gruvbox = "gruvbox.nvim",
  tokyonight = "tokyonight.nvim",
  catppuccin = "catppuccin",
  kanagawa = "kanagawa.nvim",
  ["rose-pine"] = "rose-pine",
}

local function add(plugin)
  defer.packadd(plugin)
  if plugin == "catppuccin" then
    -- catppuccin ships extra tree-sitter colour rules for CSS/JavaScript/
    -- TypeScript (in its after/ folder) that no longer match the current
    -- parsers and break colours in those languages. Drop that folder.
    for _, dir in ipairs(vim.opt.runtimepath:get()) do
      if dir:match("/catppuccin/after$") then
        vim.opt.runtimepath:remove(dir)
      end
    end
  end
end

--- Load the plugin that provides colour scheme `name` (e.g. "tokyonight-night").
function M.load_for(name)
  for prefix, plugin in pairs(M.plugins) do
    if vim.startswith(name, prefix) then
      add(plugin)
      return
    end
  end
end

--- Load every theme plugin, so the picker can list them all.
function M.load_all()
  for _, plugin in pairs(M.plugins) do
    add(plugin)
  end
end

return M
