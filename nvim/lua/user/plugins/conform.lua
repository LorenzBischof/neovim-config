local keymap = vim.keymap

keymap.set('n', '<leader>tf', function()
  if vim.b.disable_autoformat then
    vim.b.disable_autoformat = false
    vim.notify 'Enabled autoformat for current buffer'
  else
    vim.b.disable_autoformat = true
    vim.notify 'Disabled autoformat for current buffer'
  end
end, { desc = "[T]oggle [F]ormatting" })

require("conform").setup({
  formatters_by_ft = {
    beancount = { "bean-format" },
  },
  format_on_save = function(bufnr)
    if vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})
