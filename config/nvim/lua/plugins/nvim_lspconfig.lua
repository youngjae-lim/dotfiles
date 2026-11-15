return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {},
      emmet_language_server = {
        filetypes = {
          "html",
          "css",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "templ",
          "heex",
        },
      },
      html = {
        filetypes = { "html", "astro", "heex" },
      },
      tailwindcss = {
        filetypes = { "templ", "astro", "javascriptreact", "javascript", "typescriptreact", "typescript", "heex" },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              templ = "html",
              astro = "html",
              heex = "html",
            },
          },
        },
      },
    },
    setup = {
      eslint = function()
        require("lazyvim.util").lsp.on_attach(function(client)
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,
    },
  },
}
