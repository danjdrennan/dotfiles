local keymap = vim.keymap.set

-- Keymaps for better default experience
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- File explorer
keymap("n", "<leader>pv", vim.cmd.Ex)

-- Center on G
keymap("n", "G", "Gzz")

-- Quickfix navigation
keymap("n", "<C-n>", ":cnext<CR>")
keymap("n", "<C-p>", ":cprev<CR>")

-- Buffer management
keymap("n", "<leader>bl", function() vim.cmd.buffers() end, { desc = "List buffers" })
keymap("n", "<leader>bd", function()
  local current_buff = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buff and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = "Delete all other buffers" })

-- Diagnostics
-- Neovim 0.11+ provides [d / ]d for jumping between diagnostics by default.
-- These add the float + qflist bindings from the old config.
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
keymap("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Open diagnostics list" })

-- LSP keymaps applied on attach
-- Neovim 0.11+ provides these defaults:
--   grn  = rename          gra  = code action    grr = references
--   gri  = implementation  grt  = type def       gO  = document symbols
--   C-s  = signature help  K    = hover
--
-- We layer on telescope-powered variants and a few extras.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local function map(keys, func, desc)
      keymap("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    local ok, builtin = pcall(require, "telescope.builtin")
    if ok then
      map("gd", builtin.lsp_definitions, "Goto Definition")
      map("grr", builtin.lsp_references, "Goto References")
      map("gri", builtin.lsp_implementations, "Goto Implementation")
      map("grt", builtin.lsp_type_definitions, "Type Definition")
      map("<leader>ds", builtin.lsp_document_symbols, "Document Symbols")
      map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")
    end

    -- Preserve old keymaps that don't conflict with builtins
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
    map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
    map("<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "Workspace List Folders")

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
      vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
  end,
})

-- Insert centered section comment (custom utility)
keymap("n", "<leader>ic", function()
  local input = vim.fn.input("Section Name: ")
  if input == "" then return end

  local width = 75
  local text = input:upper()

  local cms = vim.bo.commentstring
  local comment_char = cms:gsub("%%s.*", ""):gsub("%s+$", "")

  local padding = math.floor((width - #text) / 2)
  local left_pad = string.rep(" ", padding)

  local border = comment_char .. " " .. string.rep("=", width)
  local centered_text = comment_char .. left_pad .. text

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, false, { border, centered_text, border, "" })
  pcall(vim.api.nvim_win_set_cursor, 0, { row + 4, 0 })
end, { desc = "Insert centered section comment" })
