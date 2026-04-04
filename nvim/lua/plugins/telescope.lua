return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>?", "<cmd>Telescope oldfiles<cr>", desc = "Find recently opened files" },
    { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Find existing buffers" },
    { "<leader>/", function()
        require("telescope.builtin").current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
        )
      end, desc = "Fuzzy search in current buffer" },
    { "<leader>s/", function()
        require("telescope.builtin").live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
      end, desc = "Search in open files" },
    { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "Search Telescope builtins" },
    { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Search git files" },
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Search files" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search help" },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Search current word" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Search by grep" },
    { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Search diagnostics" },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Search resume" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search keymaps" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function() return vim.fn.executable("make") == 1 end,
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = { ["<C-u>"] = false, ["<C-d>"] = false },
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    pcall(require("telescope").load_extension, "fzf")
  end,
}
