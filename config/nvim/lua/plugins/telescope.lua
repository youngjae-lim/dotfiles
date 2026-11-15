return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = { "make" },
      config = function()
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("noice")
      end,
    },
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
            -- -- disable the keymap to grep files
      -- change a keymap
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>r", "<cmd>Telescope live_grep<cr>", desc = "Grep Files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep Files" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
      {
        "<leader>nf",
        function()
          require("telescope.builtin").find_files({
            prompt_title = "Find quick notes",
            cwd = "~/Google Drive/My Drive/Notes/",
          })
        end,
        desc = "Find quick notes in my Google Drive",
      },
      -- grep notes
      {
        "<leader>ng",
        function()
          require("telescope.builtin").live_grep({
            hidden = true,
            search_dirs = { "~/Google Drive/My Drive/Notes/" },
            prompt_title = "Grep quick notes",
            path_display = { "smart" },
          })
        end,
        desc = "Grep quick notes in my Google Drive",
      },
      { "<leader>/", false },
      { "<leader>fF", false },
      { "<leader>fr", false },
      { "<leader>fR", false },
      { "<leader>sG", false },
      { "<leader>sW", false },
    },
    -- change some options
    opts = {
      extensions = {
        "fzf",
        "noice",
      },
      defaults = {
        find_command = {
          "rg",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--glob=!node_modules",
          "--glob=!*_templ.go",
        },
        -- change default sorting to ascending
        prompt_prefix = "🔍 ",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          -- move prompt to top
          prompt_position = "top",
        },
        path_display = {
          "smart",
        },
        file_ignore_patterns = {
          ".git/",
          "node_modules/",
          "vendor/",
          "%_templ.go",
        },
        mappings = {
          i = {
            ["<esc>"] = require("telescope.actions").close,
            -- ["q"] = require("telescope.actions").close,
          },
          n = {
            ["<esc>"] = require("telescope.actions").close,
            ["q"] = require("telescope.actions").close,
          },
        },
      },
    },
  },
}
