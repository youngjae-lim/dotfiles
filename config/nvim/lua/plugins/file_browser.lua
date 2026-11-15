-- Loaded by: lua/plugins.lua
-- Local plugins required: telescope.nvim
-- Opens a file browser in Telescope with the current file's directory as the root.
return {
  "nvim-telescope/telescope-file-browser.nvim",
  keys = {
    {
      "<leader>sB",
      ":Telescope file_browser path=%:p:h=%:p:h<cr>",
      desc = "Browse Files",
    },
    {
      "<leader>sp",
      ":Telescope file_browser path=~/Projects/<cr>",
      desc = "Browse Projects",
    },
  },
  config = function()
    require("telescope").load_extension("file_browser")
  end,
}
