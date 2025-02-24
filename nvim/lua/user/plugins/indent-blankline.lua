vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = "#333333" })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = "#303030" })
require("ibl").setup {
  indent = {
    char = "▏",
    highlight = "IndentBlanklineChar",
  },
  scope = {
    enabled = false,
  },
}

-- Dirty hack to ensure cursor does not change color
local ns_id = vim.api.nvim_create_namespace('indent_blankline')
vim.api.nvim_create_augroup("CursorHighlightGroup", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = "CursorHighlightGroup",
  callback = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
    if char == " " or char == "" then
      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_extmark(bufnr, ns_id, line - 1, col, {
        virt_text = { { " ", "NonText" } },
        virt_text_pos = 'overlay',
        hl_mode = 'combine'
      })
    end
  end,
})
