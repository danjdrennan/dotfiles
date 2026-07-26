return {
  -- https://github.com/ellisonleao/gruvbox.nvim#configuration
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    -- Default options:
    require("gruvbox").setup({
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
      strikethrough = false,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      inverse = true,
      contrast = "",
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    })
    vim.cmd.colorscheme("gruvbox")
  end,
}
