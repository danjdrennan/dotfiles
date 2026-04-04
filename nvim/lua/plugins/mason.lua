return {
  "mason-org/mason.nvim",
  lazy = false,
  opts = {
    ensure_installed = {
      "clangd",
      "lua-language-server",
      "ruff",
      "rust-analyzer",
      "texlab",
      "tinymist",
      "ty",
      "zls",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- Auto-install any missing servers
    local mr = require("mason-registry")
    for _, name in ipairs(opts.ensure_installed or {}) do
      local p = mr.get_package(name)
      if not p:is_installed() then
        p:install()
      end
    end
  end,
}
