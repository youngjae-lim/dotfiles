-- Linters that aren't language servers (nvim-lint). ESLint is not here: its
-- language server (lsp.lua) already reports ESLint problems.
-- Runs when a file is opened, saved, or you leave insert mode. ;l runs it now.
local defer = require("config.defer")

defer.on({ "BufReadPost", "BufNewFile" }, function()
  defer.packadd("nvim-lint")
  local lint = require("lint")

  lint.linters_by_ft = {
    go = { "golangcilint" },
    dockerfile = { "hadolint" },
    markdown = { "markdownlint" },
    css = { "stylelint" },
    scss = { "stylelint" },
  }

  -- Only run linters that are installed, so a missing one doesn't error
  local function try_lint()
    local names = lint.linters_by_ft[vim.bo.filetype] or {}
    local available = vim.tbl_filter(function(name)
      local linter = lint.linters[name]
      if type(linter) == "function" then
        linter = linter()
      end
      local cmd = type(linter) == "table" and linter.cmd or name
      if type(cmd) == "function" then
        cmd = cmd()
      end
      return vim.fn.executable(cmd) == 1
    end, names)
    if #available > 0 then
      lint.try_lint(available)
    end
  end

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("lean-lint", { clear = true }),
    callback = try_lint,
  })
  vim.keymap.set("n", ";l", try_lint, { desc = "Lint this file" })
  try_lint() -- the file that triggered loading
end)
