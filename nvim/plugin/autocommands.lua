if vim.g.did_load_autocommands_plugin then
    return
end
vim.g.did_load_autocommands_plugin = true

local api = vim.api

local keymap = vim.keymap
