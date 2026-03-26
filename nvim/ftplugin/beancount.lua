local buf_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
local root_file = vim.fs.find('main.bean', {
  path = buf_dir,
  upward = true,
  type = 'file',
})[1]

vim.g.beancount_root = root_file or (buf_dir .. '/main.bean')
