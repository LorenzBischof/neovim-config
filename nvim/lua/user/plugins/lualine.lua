require('lualine').setup {
  sections = {
    lualine_x = {
      { 'lsp_status', ignore_lsp = { 'copilot' } },
      'encoding', 'fileformat', 'filetype'
    }
  }
}
