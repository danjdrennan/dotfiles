return {
  cmd = { "zls" },
  filetypes = { "zig" },
  root_markers = { "build.zig", ".git" },
  settings = {
    zls = {
      zig_exe_path = vim.fn.expand("$HOME/.local/bin/zig"),
    },
  },
}
