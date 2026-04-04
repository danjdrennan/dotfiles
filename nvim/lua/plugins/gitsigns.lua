return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map({ "n", "v" }, "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.nav_hunk('next') end)
        return "<Ignore>"
      end, { expr = true, desc = "Jump to next hunk" })

      map({ "n", "v" }, "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.nav_hunk('prev') end)
        return "<Ignore>"
      end, { expr = true, desc = "Jump to previous hunk" })

      -- Actions (visual)
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage git hunk" })
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset git hunk" })

      -- Actions (normal)
      map("n", "<leader>hs", gs.stage_hunk, { desc = "Git stage hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { desc = "Git reset hunk" })
      map("n", "<leader>hS", gs.stage_buffer, { desc = "Git stage buffer" })
      map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
      map("n", "<leader>hR", gs.reset_buffer, { desc = "Git reset buffer" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview git hunk" })
      map("n", "<leader>hb", function() gs.blame_line({ full = false }) end, { desc = "Git blame line" })
      map("n", "<leader>hd", gs.diffthis, { desc = "Git diff against index" })
      map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Git diff against last commit" })

      -- Toggles
      map("n", "<leader>tb",
        gs.toggle_current_line_blame,
        { desc = "Toggle git blame line" }
      )
      map("n", "<leader>td",
        gs.preview_hunk_inline,
        { desc = "Toggle git show deleted" }
      )

      -- Text object
      map({ "o", "x" }, "ih",
        ":<C-U>Gitsigns select_hunk<CR>",
        { desc = "Select git hunk" }
      )
    end,
  },
}
