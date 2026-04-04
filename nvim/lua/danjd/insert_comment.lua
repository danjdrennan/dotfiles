vim.keymap.set('n', '<leader>ic', function()
  local input = vim.fn.input("Section Name: ")
  if input == "" then return end

  local width = 75
  local text = input:upper()

  -- Extract the language's comment prefix (e.g., "#", "//", "--")
  local cms = vim.bo.commentstring
  local comment_char = cms:gsub("%%s.*", ""):gsub("%s+$", "")

  -- Calculate padding for centering within the 75-char width
  -- Subtracting comment_char length to keep the total width consistent
  local padding = math.floor((width - #text) / 2)
  local left_pad = string.rep(" ", padding)

  -- Construct the lines
  local border = comment_char .. " " .. string.rep("=", width)
  -- This places the comment_char at column 1, followed by padding and text
  local centered_text = comment_char .. left_pad .. text

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  -- Insert the 3 lines and an extra empty line for immediate typing
  vim.api.nvim_buf_set_lines(0, row, row, false, { border, centered_text, border, "" })

  -- Move cursor to the empty line (row + 4)
  pcall(vim.api.nvim_win_set_cursor, 0, { row + 4, 0 })
end, { desc = "Insert centered section with column 1 comments" })
