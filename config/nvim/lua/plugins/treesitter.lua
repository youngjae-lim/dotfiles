-- Syntax highlighting and indentation from tree-sitter parsers.
-- Neovim has the tree-sitter engine built in; nvim-treesitter installs the
-- parsers. Building a parser needs the `tree-sitter` CLI (from mise) and a C
-- compiler (Xcode Command Line Tools).

-- Parsers for the languages you use. Add one here, restart, and it installs.
-- stylua: ignore
local parsers = {
  -- Go
  "go", "gomod", "gosum", "gowork", "gotmpl",
  -- JavaScript / TypeScript / frameworks
  "javascript", "typescript", "tsx", "jsdoc", "svelte", "astro", "graphql",
  -- Web
  "html", "css", "scss",
  -- PHP / Laravel
  "php", "phpdoc", "blade",
  -- Elixir
  "elixir", "heex", "eex",
  -- Config and data
  "dockerfile", "yaml", "toml", "json", "sql",
  -- Notes, shell, Neovim itself, git
  "markdown", "markdown_inline", "bash", "lua", "luadoc", "vim", "vimdoc", "query",
  "regex", "diff", "gitcommit", "git_rebase", "gitignore",
}

-- Install only what's missing (runs in the background; a no-op when complete)
-- Parsers go to stdpath("data")/site/parser, their queries (the rules for
-- colours, folds, indents) to site/queries. That folder is on the runtimepath
-- by default.
local ts = require("nvim-treesitter")
local installed = {}
for _, lang in ipairs(ts.get_installed()) do
  installed[lang] = true
end
local missing = vim.tbl_filter(function(lang)
  return not installed[lang]
end, parsers)
if #missing > 0 then
  ts.install(missing)
end

-- Laravel Blade templates are *.blade.php
vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })

-- Start tree-sitter for any file whose parser is installed; others keep Vim's
-- regular syntax highlighting.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    if not pcall(vim.treesitter.start, ev.buf) then
      return
    end
    -- Tree-sitter indenting is experimental: use it only where the language has indent rules
    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
    if lang and vim.treesitter.query.get(lang, "indents") then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Auto-close and auto-rename HTML/JSX/Svelte/Astro/Blade tags
require("nvim-ts-autotag").setup()
