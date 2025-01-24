local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

local function has_words_before()
    local unpack_ = unpack or table.unpack
    local line, col = unpack_(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---@param source string|table
local function complete_with_source(source)
    if type(source) == 'string' then
        cmp.complete { config = { sources = { { name = source } } } }
    elseif type(source) == 'table' then
        cmp.complete { config = { sources = { source } } }
    end
end

cmp.setup {
    completion = {
        completeopt = 'menu,menuone,noselect,preview',
    },
    formatting = {
        format = lspkind.cmp_format {
            mode = 'symbol_text',
            with_text = true,
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            menu = {
                buffer = '[BUF]',
                nvim_lsp = '[LSP]',
                nvim_lsp_signature_help = '[LSP]',
                nvim_lsp_document_symbol = '[LSP]',
                nvim_lua = '[API]',
                path = '[PATH]',
                luasnip = '[SNIP]',
            },
        },
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping(function(_)
            if cmp.visible() then
                cmp.scroll_docs(-4)
            else
                complete_with_source('buffer')
            end
        end, { 'i', 's' }),
        ['<C-f>'] = cmp.mapping(function(_)
            if cmp.visible() then
                cmp.scroll_docs(4)
            else
                complete_with_source('path')
            end
        end, { 'i', 's' }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- expand_or_jumpable(): Jump outside the snippet region
                -- expand_or_locally_jumpable(): Only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- expand_or_jumpable(): Jump outside the snippet region
                -- expand_or_locally_jumpable(): Only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<CR>'] = cmp.mapping.confirm {
            select = false,
        },
    },
    sources = cmp.config.sources {
        -- The insertion order influences the priority of the sources
        {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        },
        { name = 'nvim_lsp',                keyword_length = 3 },
        { name = 'nvim_lsp_signature_help', keyword_length = 3 },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
}
