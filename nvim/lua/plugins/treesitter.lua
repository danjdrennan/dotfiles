return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      -- Parsers bundled with Neovim core (no need to install)
      local bundled = { "c", "lua", "markdown", "vim", "vimdoc", "query" }

      local wanted = {
        "bash", "cmake", "cpp", "go", "latex",
        "python", "rust", "toml", "typst", "yaml", "zig",
      }

      local installed = require("nvim-treesitter").get_installed()
      local to_install = vim.iter(wanted)
        :filter(function(p)
          return not vim.tbl_contains(installed, p)
            and not vim.tbl_contains(bundled, p)
        end)
        :totable()

      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      -- Enable treesitter highlighting for all buffers with a parser
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- main branch API: config is just options, keymaps are manual
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- Textobject selection
      local select_maps = {
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      }
      for keys, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, keys, function()
          select.select_textobject(query)
        end, { desc = "Select " .. query })
      end

      -- Movement
      local move_maps = {
        ["]m"] = { move.goto_next_start, "@function.outer", "Next function start" },
        ["]]"] = { move.goto_next_start, "@class.outer", "Next class start" },
        ["]M"] = { move.goto_next_end, "@function.outer", "Next function end" },
        ["]["] = { move.goto_next_end, "@class.outer", "Next class end" },
        ["[m"] = { move.goto_previous_start, "@function.outer", "Prev function start" },
        ["[["] = { move.goto_previous_start, "@class.outer", "Prev class start" },
        ["[M"] = { move.goto_previous_end, "@function.outer", "Prev function end" },
        ["[]"] = { move.goto_previous_end, "@class.outer", "Prev class end" },
      }
      for keys, spec in pairs(move_maps) do
        vim.keymap.set({ "n", "x", "o" }, keys, function()
          spec[1](spec[2])
        end, { desc = spec[3] })
      end

      -- Swap
      vim.keymap.set("n", "<leader>ma", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap parameter forward" })
      vim.keymap.set("n", "<leader>mA", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap parameter backward" })
    end,
  },
}
