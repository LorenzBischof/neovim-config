require('avante_lib').load()

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

set_anthropic_key()

require('avante').setup({
  -- Your config here!
})
