local util = require("conform.util")
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    ---@class ConformOpts
    local opts = {
      -- LazyVim will use these options when formatting with the conform.nvim formatter
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
      },
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "beautysh" },
        -- go = { "gofumpt", "gofmt", "goimports" },
        go = { "gofumpt", "gofmt" },
        -- php = { "pint" },
        blade = { "blade-formatter", "rustywind" },
        python = { "black" },
        svelte = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        graphql = { "prettier" },
        markdown = { "prettier" },
        astro = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        sass = { "prettier" },
        yaml = { "yamlfix" },
        templ = { "templ" },
        heex = { "mix" },
        elixir = { "mix" },
        eelixir = { "mix" },
      },
      -- LazyVim will merge the options you set here with builtin formatters.
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        injected = { options = { ignore_errors = true } },
        -- # Example of using dprint only when a dprint.json file is present
        -- dprint = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
        --
        -- # Example of using shfmt with extra args
        -- shfmt = {
        --   extra_args = { "-i", "2", "-ci" },
        -- },
        -- mix = {
        --   command = "mix",
        --   args = { "format", "-" },
        -- },
        -- pint = {
        --   meta = {
        --     url = "https://github.com/laravel/pint",
        --     description = "Laravel Pint is an opinionated PHP code style fixer for minimalists. Pint is built on top of PHP-CS-Fixer and makes it simple to ensure that your code style stays clean and consistent.",
        --   },
        --   command = util.find_executable({
        --     vim.fn.stdpath("data") .. "/mason/bin/pint",
        --     "vendor/bin/pint",
        --   }, "pint"),
        --   args = { "$FILENAME" },
        --   stdin = false,
        -- },
        -- php = {
        --   command = util.find_executable({
        --     vim.fn.stdpath("data") .. "/mason/bin/php-cs-fixer",
        --     "vendor/bin/php-cs-fixer",
        --   }, "php-cs-fixer"),
        --   args = { "fix", "$FILENAME" },
        --   stdin = false,
        -- },
      },
    }
    return opts
  end,
}
