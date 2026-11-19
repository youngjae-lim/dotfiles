-- Completion menu (blink.cmp) and Copilot suggestions.
--
-- Keys while typing:
--   Enter        accept the selected menu item
--   Ctrl+Space   open the menu / docs
--   Ctrl+E       close the menu
--   Up / Down, Ctrl+P / Ctrl+N   move in the menu
--   Tab          accept the Copilot suggestion (grey text); otherwise jump
--                to the next snippet field, or insert a tab
--   Ctrl+G       show the next Copilot suggestion (lsp.lua)
--   Ctrl+S       show the function signature
--   Ctrl+U / Ctrl+D   scroll the docs popup (Ctrl+B is herdr's prefix)
require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    ["<Tab>"] = {
      function()
        return vim.lsp.inline_completion.get() -- true if a Copilot suggestion was accepted
      end,
      "snippet_forward",
      "fallback",
    },
    ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
    ["<C-k>"] = false, -- Karabiner turns Ctrl+K into an arrow key; use Ctrl+S
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
  },
  completion = {
    list = { selection = { preselect = false } }, -- Enter inserts a newline until you pick an item
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  signature = { enabled = true },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
