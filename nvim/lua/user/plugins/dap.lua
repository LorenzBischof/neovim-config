require("nvim-dap-virtual-text").setup()

local dap = require('dap')
local dapui = require('dapui')

dapui.setup {
  layouts = {
    {
      elements = {
        "scopes",
        "console",
      },
      size = 0.25,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
    element = "console",
  },
}

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

local keymap = vim.keymap
keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
keymap.set('n', '<leader>dc', dap.continue, { desc = "Run/Continue" })
keymap.set('n', '<leader>do', dap.step_over, { desc = "Step Over" })
keymap.set('n', '<leader>de', dap.step_out, { desc = "Step Out (Exit)" })
keymap.set('n', '<leader>di', dap.step_into, { desc = "Step Into" })
keymap.set('n', '<leader>du', dapui.toggle, { desc = "Step Into" })


require('dap-go').setup {}
