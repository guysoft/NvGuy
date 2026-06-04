require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Mouse navigation: Ctrl+click → LSP go-to-definition, Ctrl+right-click → jump back
map("n", "<C-LeftMouse>", function()
  local keys = vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
  vim.schedule(function()
    vim.lsp.buf.definition()
  end)
end, { desc = "LSP go-to-definition under mouse" })

map("n", "<C-RightMouse>", "<C-o>", { desc = "Jump back in jumplist" })

-- Side mouse buttons → jumplist forward/back
map({ "n", "v" }, "<X1Mouse>", "<C-o>", { desc = "Jump back in jumplist (mouse back)" })
map({ "n", "v" }, "<X2Mouse>", "<C-i>", { desc = "Jump forward in jumplist (mouse forward)" })

