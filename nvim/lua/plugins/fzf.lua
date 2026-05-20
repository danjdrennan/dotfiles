return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  keys = {
    { "<leader>?", "<cmd>FzfLua oldfiles<cr>", desc = "Find recently opened files" },
    { "<leader>b", "<cmd>FzfLua buffers<cr>",  desc = "Find existing buffers" },
    {
      "<leader>/",
      function()
        require("fzf-lua").blines({
          winopts = { height = 0.6, width = 0.8, },
        })
      end,
      desc = "Fuzzy search in current buffer"
    },
    { "<leader>ss", "<cmd>FzfLua builtin<cr>",              desc = "Search FzfLua builtins" },
    { "<leader>gf", "<cmd>FzfLua git_files<cr>",            desc = "Search git files" },
    { "<leader>sf", "<cmd>FzfLua files<cr>",                desc = "Search files" },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>",            desc = "Search help" },
    { "<leader>sw", "<cmd>FzfLua grep_cword<cr>",           desc = "Search current word" },
    { "<leader>sg", "<cmd>FzfLua live_grep<cr>",            desc = "Search by grep" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Search diagnostics" },
    { "<leader>sr", "<cmd>FzfLua resume<cr>",               desc = "Search resume" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>",              desc = "Search keymaps" },
  },
  config = function()
    local fzf = require("fzf-lua")
    -- ctrl-i (=Tab), ctrl-h (=Backspace), and ctrl-f (=half-page-down) are
    -- overloaded: the plugin process currently wins input handling, so these
    -- work as intended. If neovim changes how it routes keyboard input to
    -- embedded processes, these three bindings are the ones most likely to break.
    fzf.setup({
      keymap = {
        fzf = {
          ["alt-a"]          = "ignore",
          ["alt-g"]          = "ignore",
          ["alt-G"]          = "ignore",
          ["alt-shift-down"] = "ignore",
          ["alt-shift-up"]   = "ignore",
        },
      },
      actions = {
        files = {
          ["ctrl-q"] = { fn = fzf.actions.file_sel_to_qf, prefix = "select-all+" },
          ["ctrl-l"] = { fn = fzf.actions.file_sel_to_ll, prefix = "select-all+" },
          ["ctrl-i"] = { fn = fzf.actions.toggle_ignore,  reuse = true, header = false },
          ["ctrl-h"] = { fn = fzf.actions.toggle_hidden,  reuse = true, header = false },
          ["ctrl-f"] = { fn = fzf.actions.toggle_follow,  reuse = true, header = false },
          ["alt-q"]  = false,
          ["alt-Q"]  = false,
          ["alt-i"]  = false,
          ["alt-h"]  = false,
          ["alt-f"]  = false,
        },
      },
    })
  end,
}
