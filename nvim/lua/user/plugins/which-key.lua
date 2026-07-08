require('which-key').setup {
  preset = 'helix',
  delay = 0,
  -- Document existing key chains
  spec = {
    { '<leader>d', group = '[D]ebug / [D]ocument' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>w', group = '[W]orkspace' },
    { '<leader>t', group = '[T]oggle' },
  },
}
