local treesitter = require('nvim-treesitter')
vim.g.skip_ts_context_comment_string_module = true

---@diagnostic disable-next-line: missing-fields
treesitter.setup {}

require('ts_context_commentstring').setup()

local ts_start_group = vim.api.nvim_create_augroup('user-treesitter-start', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
  group = ts_start_group,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= '' then
      return
    end

    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Tree-sitter based folding
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
