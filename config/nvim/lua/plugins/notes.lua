-- Notes: Neovim's side of the `notes` script (~/.local/bin/notes), which
-- keeps markdown notes in Google Drive and renders them with pandoc.
--   <leader>nf   find a note (markdown files under <Drive>/Notes)
--   <leader>ng   search text inside your notes
--   <leader>nr   render this note to PDF   (notes pdf  → ./pdf/<name>.pdf)
--   <leader>np   render this note to slides (notes ppt → ./presentation/)
-- Daily notes (note-YYYY-MM-DD.md, from `nt`) re-render to PDF on every save,
-- in the background, so `on` (notes recent) always opens the latest.
local pick = require("plugins.finder").pick

-- Same folder the script uses; GOOGLE_DRIVE_DIR overrides it there and here
local drive = vim.env.GOOGLE_DRIVE_DIR or vim.fs.joinpath(vim.env.HOME, "Google Drive/My Drive")
local notes_dir = vim.fs.joinpath(drive, "Notes")

-- Run `notes <cmd> <file>` without freezing the editor; report the result
local function render(cmd, file, quiet)
  vim.system({ "notes", cmd, file }, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify(("notes %s failed:\n%s"):format(cmd, res.stderr), vim.log.levels.ERROR)
      elseif not quiet then
        vim.notify("Rendered " .. vim.trim(res.stdout))
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
  render("pdf", vim.fn.expand("%:p"))
end, "Render note to PDF")
map("<leader>np", function()
  render("ppt", vim.fn.expand("%:p"))
end, "Render note to slides")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "note-*.md",
  desc = "Re-render daily notes to PDF",
  callback = function(ev)
    render("pdf", ev.file, true)
  end,
})
