return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.setup({})

    -- LaTeX/markdown math: auto-pair $ symbols
    npairs.add_rules({
      Rule("$", "$", { "tex", "latex", "markdown", "typst" })
        :with_move(cond.done()),
    })
  end,
}
