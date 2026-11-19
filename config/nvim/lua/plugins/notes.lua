-- Notes: Neovim's side of the `notes` script (~/.local/bin/notes). Notes are
-- markdown files in a git repo (~/Notes), rendered to PDF with pandoc.
--   <leader>nf   find a note
--   <leader>ng   search text inside your notes
--   <leader>nr   render this note to PDF    (→ <its folder>/pdf/<name>.pdf)
--   <leader>np   render this note to slides (→ <its folder>/presentation/)
--   <leader>nh   history of this note (every saved version; Enter shows the change)
--   <leader>nc   commit all notes and push them to GitHub (`notes save`;
--                asks for a short message)
-- Every note re-renders to PDF in the background when you write it, so `on`
-- and the other PDF commands always open the latest.
local pick = require("plugins.finder").pick

-- Same folder the script uses; NOTES_DIR overrides it there and here
local notes_dir = vim.env.NOTES_DIR or vim.fs.joinpath(vim.env.HOME, "Notes")

-- Run `notes <args>` without freezing the editor; report the result
local function run(args, quiet)
  vim.system(vim.list_extend({ "notes" }, args), { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify(("notes %s failed:\n%s"):format(args[1], res.stderr), vim.log.levels.ERROR)
      elseif not quiet then
        vim.notify(vim.trim(res.stdout))
      end
    end)
  end)
end

local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { desc = desc })
end

map("<leader>nf", pick("files", { cwd = notes_dir, cmd = "rg --files --glob '*.md'" }), "Find notes")
map("<leader>ng", pick("live_grep", { cwd = notes_dir }), "Search in notes")
map("<leader>nr", function()
  run({ "pdf", vim.fn.expand("%:p") })
end, "Render note to PDF")
map("<leader>np", function()
  run({ "ppt", vim.fn.expand("%:p") })
end, "Render note to slides")
map("<leader>nh", pick("git_bcommits"), "Note history")
map("<leader>nc", function()
  vim.cmd("silent! wall") -- write open notes first
  vim.ui.input({ prompt = "Save notes, message (empty = date): " }, function(msg)
    if msg ~= nil then -- nil means you pressed Esc
      run({ "save", msg })
    end
  end)
end, "Save notes to GitHub")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = notes_dir .. "/*.md", -- * also matches subfolders here
  desc = "Re-render notes to PDF",
  callback = function(ev)
    run({ "pdf", ev.match }, true) -- ev.match is the full path
  end,
})
