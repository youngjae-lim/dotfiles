-- Tiny helpers for loading plugins later instead of at startup.
local M = {}

local added = {}

--- Load a plugin registered "for later" in config/pack.lua (once).
---@param name string plugin name, e.g. "fzf-lua"
function M.packadd(name)
  if not added[name] then
    added[name] = true
    vim.cmd.packadd(name)
  end
end

--- Wrap a setup function so it runs only the first time it's called.
---@param fn fun()
---@return fun()
function M.once(fn)
  local done = false
  return function()
    if not done then
      done = true
      fn()
    end
  end
end

--- Run fn once, the first time one of the events fires.
---@param events string|string[]
---@param fn fun()
---@param pattern? string|string[]
function M.on(events, fn, pattern)
  vim.api.nvim_create_autocmd(events, {
    once = true,
    pattern = pattern,
    callback = function()
      fn()
    end,
  })
end

return M
