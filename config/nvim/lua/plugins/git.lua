-- Git: changed-line signs in the left column (mini.diff), lazygit in a tab.
--   ]h / [h       next / previous changed hunk
--   gh{motion}    apply (stage) a hunk     gH{motion}  reset it
--   <leader>gd    show the diff overlay on the current file
--   <leader>gg    lazygit (q to quit and come back)
require("mini.diff").setup({ view = { style = "sign" } })

vim.keymap.set("n", "<leader>gd", function()
  MiniDiff.toggle_overlay()
end, { desc = "Toggle diff overlay" })

vim.keymap.set("n", "<leader>gg", function()
  vim.cmd("tabnew | terminal lazygit")
  vim.cmd.startinsert()
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = 0,
    once = true,
    callback = function(ev)
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
      end)
    end,
  })
end, { desc = "Lazygit" })
