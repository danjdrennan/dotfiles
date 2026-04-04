return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 500,
    icons = { mappings = false },
    spec = {
      { "<leader>s", group = "Search" },
      { "<leader>h", group = "Git hunk", mode = { "n", "v" } },
      { "<leader>t", group = "Toggle" },
      { "<leader>w", group = "Workspace" },
      { "<leader>d", group = "Document" },
      { "<leader>m", group = "Move/swap" },
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>r", group = "Rename" },
      { "g", group = "Goto" },
      { "[", group = "Prev" },
      { "]", group = "Next" },
    },
  },
}
