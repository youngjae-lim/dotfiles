-- Every plugin is listed here, and only here.
--
-- vim.pack (built into Neovim 0.12) installs missing plugins on startup and
-- records their exact versions in nvim-pack-lock.json (commit that file).
--   Update:   <leader>pu  (or :lua vim.pack.update()), review, then :write
--   Remove:   delete the line below, then :lua vim.pack.del({ "name" })
-- Details: ~/Dotfiles/docs/11-neovim.md

local function gh(repo)
  return "https://github.com/" .. repo
end

-- Build steps after a plugin is installed or updated. Must be defined before
-- the first vim.pack.add(), so it also runs on a fresh install.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      -- Parsers must match the plugin version: rebuild them after an update.
      -- (A fresh install builds them in lua/plugins/treesitter.lua.)
      vim.schedule(function()
        pcall(function()
          require("nvim-treesitter").update()
        end)
      end)
    end
  end,
})

-- 1. Loaded at startup: needed to draw the first screen or open the first file.
vim.pack.add({
  gh("nvim-mini/mini.nvim"), -- statusline, buffer tabs, key hints, icons, surround, pairs, git signs...
  gh("nvim-treesitter/nvim-treesitter"), -- syntax parsers (version: default branch "main")
  gh("windwp/nvim-ts-autotag"), -- auto-close and rename HTML/JSX/Svelte/Astro tags
  gh("neovim/nvim-lspconfig"), -- ready-made language-server settings (data only)
  -- completion menu; a release version so a prebuilt fuzzy-matcher binary is used
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
  gh("rafamadriz/friendly-snippets"), -- snippet collection, read by blink.cmp
})

-- 2. Installed now, but loaded the first time they're needed (a key, a file
--    being opened or saved). lua/plugins/*.lua decides when, using packadd.
vim.pack.add({
  gh("ibhagwan/fzf-lua"), -- fuzzy finder (files, grep, symbols, colour schemes)
  gh("nvim-tree/nvim-tree.lua"), -- file tree sidebar
  gh("hedyhli/outline.nvim"), -- symbols outline sidebar
  gh("stevearc/conform.nvim"), -- format on save
  gh("mfussenegger/nvim-lint"), -- linters that aren't language servers

  -- Colour schemes: the one in use loads at startup, the rest when you open
  -- the picker (<leader>uC). Adding one? Also add it to lua/config/themes.lua.
  gh("ellisonleao/gruvbox.nvim"),
  gh("folke/tokyonight.nvim"),
  { src = gh("catppuccin/nvim"), name = "catppuccin" },
  gh("rebelot/kanagawa.nvim"),
  { src = gh("rose-pine/neovim"), name = "rose-pine" },
  gh("sainnhe/everforest"),
}, {
  load = function() end, -- register only; don't load yet
})
