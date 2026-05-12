return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  keys = {
    { "<leader>?", "<cmd>FzfLua oldfiles<cr>", desc = "Find recently opened files" },
    { "<leader>b", "<cmd>FzfLua buffers<cr>", desc = "Find existing buffers" },
    { "<leader>/", function()
        require("fzf-lua").blines({
          winopts = { height = 0.4, width = 0.6, preview = { hidden = "hidden" } },
        })
      end, desc = "Fuzzy search in current buffer" },
    { "<leader>s/", function()
        require("fzf-lua").live_grep({ grep_open_files = true, prompt = "Live Grep in Open Files> " })
      end, desc = "Search in open files" },
    { "<leader>ss", "<cmd>FzfLua builtin<cr>", desc = "Search FzfLua builtins" },
    { "<leader>gf", "<cmd>FzfLua git_files<cr>", desc = "Search git files" },
    { "<leader>sf", "<cmd>FzfLua files<cr>", desc = "Search files" },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Search help" },
    { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Search current word" },
    { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Search by grep" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Search diagnostics" },
    { "<leader>sr", "<cmd>FzfLua resume<cr>", desc = "Search resume" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Search keymaps" },
  },
}
