local treesitter = require('nvim-treesitter')
vim.g.skip_ts_context_comment_string_module = true

---@diagnostic disable-next-line: missing-fields
treesitter.setup {}

require('ts_context_commentstring').setup()

-- Tree-sitter based folding
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
