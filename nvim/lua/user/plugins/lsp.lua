local api = vim.api
local keymap = vim.keymap

vim.opt.completeopt = { 'menu,menuone,noselect,popup,fuzzy' }

vim.schedule(function()
  require("codesettings").setup {}
end)
vim.lsp.config('*', {
  before_init = function(_, config)
    for k, v in pairs(require('codesettings').with_local_settings(config.name, config)) do
      config[k] = v
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    vim.lsp.codelens.enable(true, { bufnr = event.buf })

    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buf = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = true,
        -- Remove function signature
        --convert = function(item)
        --  return { abbr = item.label:gsub("%b()", "") }
        --end,
      })
      -- TODO: use autocomplete option with Neovim 0.12
      vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
        buffer = event.buf,
        callback = function()
          vim.lsp.completion.get()
        end
      })
      local pumMaps = {
        ['<Tab>'] = '<C-n>',
        ['<Down>'] = '<C-n>',
        ['<S-Tab>'] = '<C-p>',
        ['<Up>'] = '<C-p>',
        ['<CR>'] = '<C-y>',
      }

      for insertKmap, pumKmap in pairs(pumMaps) do
        vim.keymap.set(
          { 'i' },
          insertKmap,
          function()
            return vim.fn.pumvisible() == 1 and pumKmap or insertKmap
          end,
          { expr = true }
        )
      end
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

vim.diagnostic.config {
  virtual_text = true,
  -- virtual_lines = true,
  signs = {
    text = { ERROR = '', WARN = '', INFO = '', HINT = '' }
  },
}

-- Nix
vim.lsp.enable('nixd')
vim.lsp.config('nixd', {
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

-- Lua
vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {})

-- OpenTofu / Terraform
vim.lsp.enable('tofu_ls')
vim.lsp.config('tofu_ls', {})

-- Rego
vim.lsp.enable('regal')
vim.lsp.config('regal', {
  init_options = {
    enableDebugCodelens = true,
    evalCodelensDisplayInline = true,
  },
})
