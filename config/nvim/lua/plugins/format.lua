-- Format on save with conform.nvim. Loaded when the first file is opened.
--   <leader>cf   format now
--   <leader>uf   toggle format-on-save (this buffer: <leader>uF)
--
-- Formatters come from the project first (node_modules/.bin, vendor/bin),
-- then from your PATH (mise). If a file type isn't listed, the language
-- server formats it (e.g. intelephense for PHP).
local defer = require("config.defer")

local setup = defer.once(function()
  defer.packadd("conform.nvim")
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      go = { "gofumpt" },
      blade = { "blade-formatter", "rustywind" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      svelte = { "prettier" },
      astro = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      toml = { "taplo" },
      elixir = { "mix" },
      eelixir = { "mix" },
      heex = { "mix" },
      -- php = { "pint" }, -- Laravel Pint from the project's vendor/bin, when you want it
    },
    default_format_opts = { lsp_format = "fallback", timeout_ms = 3000 },
    format_on_save = function(buf)
      if vim.g.autoformat == false or vim.b[buf].autoformat == false then
        return nil
      end
      return {}
    end,
  })
end)

defer.on({ "BufReadPre", "BufNewFile" }, setup)

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  setup()
  require("conform").format()
end, { desc = "Format" })

vim.keymap.set("n", "<leader>uf", function()
  vim.g.autoformat = vim.g.autoformat == false
  vim.notify("Format on save: " .. (vim.g.autoformat == false and "off" or "on"))
end, { desc = "Toggle format on save" })

vim.keymap.set("n", "<leader>uF", function()
  vim.b.autoformat = vim.b.autoformat == false
  vim.notify("Format on save (this buffer): " .. (vim.b.autoformat == false and "off" or "on"))
end, { desc = "Toggle format on save (buffer)" })
