-- Notes: Neovim's side of the `notes` script (~/.local/bin/notes). Notes are
-- markdown files in a git repo (~/Notes), rendered to PDF with pandoc.
--   <leader>nf   find a note
--   <leader>ng   search text inside your notes
--   <leader>nr   render this note to PDF    (→ <its folder>/pdf/<name>.pdf)
--   <leader>np   render this note to slides (→ <its folder>/presentation/)
--   <leader>nh   history of this note (every saved version; Enter shows the change)
--   <leader>nc   commit all notes and push them to GitHub (`notes save`;
--                asks for a short message)
--   ;ts          (while typing in a markdown file) add a small time stamp:
--                "## Standup;ts" becomes "## Standup · *2026-11-20 08:55*".
--                Typed quickly it works anywhere; typed slowly, put a space
--                before it and one after ("Standup ;ts "), and it expands then.
--   <leader>nt   the same, at the end of the current line
-- Every note re-renders to PDF in the background when you write it, so `on`
-- and the other PDF commands always open the latest.
local pick = require("plugins.finder").pick

-- Same folder the script uses; NOTES_DIR overrides it there and here
local notes_dir = vim.env.NOTES_DIR or vim.fs.joinpath(vim.env.HOME, "Notes")

-- Run `notes <args>` without freezing the editor; report the result.
-- detach: keep rendering even if you quit Neovim right after saving
-- (otherwise quitting stops pandoc halfway and no PDF appears).
local function run(args, quiet)
  vim.system(vim.list_extend({ "notes" }, args), { text = true, detach = true }, function(res)
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

-- Time stamps: in italics, so they read as a small note next to your text
local function stamp(no_space)
  return (no_space and "" or " ") .. "· *" .. os.date("%Y-%m-%d %H:%M") .. "*"
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  desc = "Time stamp keys in markdown",
  callback = function(ev)
    -- Fast: a key sequence (each key within 'timeoutlen', 300 ms)
    vim.keymap.set("i", ";ts", stamp, { buffer = ev.buf, expr = true, desc = "Insert time stamp" })
    -- Slow: an abbreviation, which expands when you type a space or Enter after it
    vim.keymap.set("ia", ";ts", function()
      return stamp(true)
    end, { buffer = ev.buf, expr = true, desc = "Insert time stamp" })
    vim.keymap.set("n", "<leader>nt", function()
      vim.api.nvim_set_current_line(vim.api.nvim_get_current_line() .. stamp())
    end, { buffer = ev.buf, desc = "Add time stamp to line" })
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = notes_dir .. "/*.md", -- * also matches subfolders here
  desc = "Re-render notes to PDF",
  callback = function(ev)
    run({ "pdf", ev.match }, true) -- ev.match is the full path
  end,
})
