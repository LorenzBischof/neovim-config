local lsp_progress = require('lsp-progress')

lsp_progress.setup({
  spinner = { "󰅐" },
  client_format = function(_, spinner, series_messages)
    if #series_messages > 0 then
      return spinner
    else
      return nil
    end
  end,
  format = function(messages)
    local active_clients = vim.lsp.get_clients()
    -- Remove 'copilot' from active clients
    for i, client in ipairs(active_clients) do
      if client.name == "copilot" then
        table.remove(active_clients, i)
        break
      end
    end
    if #messages > 0 then
      return table.concat(messages, " ")
    end
    -- TODO: Display the disabled icon when...
    if #active_clients <= 0 then
      return "󰜺"
    else
      return "󰗡"
    end
  end,
})

require('lualine').setup {
  sections = {
    lualine_x = {
      function()
        -- invoke `progress` here.
        return require('lsp-progress').progress()
      end,
      'encoding', 'fileformat', 'filetype'
    }
  }
}
