require('lint').linters_by_ft = {
  beancount = { 'bean_check' },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("user-nvim-lint", { clear = true }),
  callback = function() require("lint").try_lint() end,
})
