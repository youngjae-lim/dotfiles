-- Language servers: go-to-definition, rename, errors as you type, etc.
--
-- Servers are installed by mise (~/.config/mise/config.toml), not by Neovim.
-- nvim-lspconfig supplies each server's default settings; anything below
-- adjusts them; vim.lsp.enable() switches them on.
-- :LspMissing lists servers that aren't installed. :checkhealth vim.lsp for more.

-- Server name (nvim-lspconfig) -> program it runs -> where it comes from
local servers = {
  gopls = { "gopls", "mise: go:golang.org/x/tools/gopls" },
  vtsls = { "vtsls", "mise: npm:@vtsls/language-server" }, -- JS/TS/React/Solid/TanStack
  svelte = { "svelteserver", "mise: npm:svelte-language-server" },
  astro = { "astro-ls", "mise: npm:@astrojs/language-server" },
  tailwindcss = { "tailwindcss-language-server", "mise: npm:@tailwindcss/language-server" },
  html = { "vscode-html-language-server", "mise: npm:vscode-langservers-extracted" },
  cssls = { "vscode-css-language-server", "mise: npm:vscode-langservers-extracted" },
  jsonls = { "vscode-json-language-server", "mise: npm:vscode-langservers-extracted" },
  eslint = { "vscode-eslint-language-server", "mise: npm:vscode-langservers-extracted" },
  emmet_language_server = { "emmet-language-server", "mise: npm:@olrtg/emmet-language-server" },
  intelephense = { "intelephense", "mise: npm:intelephense" }, -- PHP / Laravel / Blade
  elixirls = { "elixir-ls", "Brewfile: elixir-ls" },
  yamlls = { "yaml-language-server", "mise: npm:yaml-language-server" },
  taplo = { "taplo", "mise: aqua:tamasfe/taplo" }, -- TOML
  dockerls = { "docker-langserver", "mise: npm:dockerfile-language-server-nodejs" },
  bashls = { "bash-language-server", "mise: npm:bash-language-server" },
  lua_ls = { "lua-language-server", "mise: aqua:LuaLS/lua-language-server" },
  marksman = { "marksman", "mise: aqua:artempyanykh/marksman" }, -- Markdown notes: links, headings
  copilot = { "copilot-language-server", "mise: npm:@github/copilot-language-server" },
}

-- Every server gets blink.cmp's completion capabilities
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

-- Adjustments to nvim-lspconfig's defaults
vim.lsp.config("intelephense", {
  filetypes = { "php", "blade" },
  settings = {
    intelephense = {
      files = { associations = { "*.php", "*.blade.php" }, maxSize = 5000000 },
    },
  },
})
vim.lsp.config("html", { filetypes = { "html", "astro", "heex", "blade" } })
vim.lsp.config("emmet_language_server", {
  filetypes = { "html", "css", "javascriptreact", "typescriptreact", "svelte", "astro", "heex", "blade" },
})
vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = { includeLanguages = { astro = "html", heex = "html", blade = "html" } },
  },
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
    },
  },
})

-- Switch on every server that's installed; skip the rest quietly
local missing = {}
for name, info in vim.spairs(servers) do
  if vim.fn.executable(info[1]) == 1 then
    vim.lsp.enable(name)
  else
    table.insert(missing, ("  %-22s needs `%s` (%s)"):format(name, info[1], info[2]))
  end
end
vim.api.nvim_create_user_command("LspMissing", function()
  if #missing == 0 then
    vim.notify("All language servers are installed.")
  else
    vim.notify("Not installed (add to mise, then `mise install`):\n" .. table.concat(missing, "\n"))
  end
end, { desc = "List language servers that aren't installed" })

-- Errors and warnings: shown at the end of the line, worst first
vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = "●" },
  severity_sort = true,
  float = { border = "rounded" },
})

-- Keys that exist only in buffers with a language server.
-- Neovim's built-ins also work: K hover, grn rename, gra code action,
-- grr references, gri implementation, gO symbols, [d / ]d diagnostics.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local function map(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gy", vim.lsp.buf.type_definition, "Go to type definition")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")

    -- Copilot: grey "ghost text" suggestions; Tab accepts (completion.lua)
    if client and client:supports_method("textDocument/inlineCompletion", ev.buf) then
      vim.lsp.inline_completion.enable(true, { bufnr = ev.buf })
      vim.keymap.set("i", "<C-g>", function()
        vim.lsp.inline_completion.select()
      end, { buffer = ev.buf, desc = "Next Copilot suggestion" })
    end
  end,
})
