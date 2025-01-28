-- Check for Anthropic API key file and set environment variable
local function set_anthropic_key()
  local key_file = "/run/agenix/anthropic-api-key"
  local f = io.open(key_file, "r")
  if f then
    local content = f:read("*all")
    f:close()
    vim.env.ANTHROPIC_API_KEY = content
  end
end

require('lz.n').load {
  {
    'avante.nvim',
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Ask" },
    },
    before = set_anthropic_key,
    after = function()
      require('avante_lib').load()
      require('avante').setup {}
    end
  }
}
