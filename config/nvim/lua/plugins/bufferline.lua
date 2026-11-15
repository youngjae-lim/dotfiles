return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "buffers",
        show_buffer_close_icons = false,
        show_close_icon = false,
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          -- style = 'icon' | 'underline' | 'none',
          style = "underline",
        },
      },
    },
  },
}
