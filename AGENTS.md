# Repository Notes

- Plugins and runtime tools are managed by Nix, not a plugin manager. Add plugin packages and external tools in `nix/neovim-overlay.nix`.
- Lua only wires config. To enable a plugin, usually do both: add the package in `nix/neovim-overlay.nix` and require its module from `nvim/lua/user/plugins/init.lua`.
- Use `nix develop` or direnv before testing changes. The dev shell exposes `nvim-dev` and symlinks this repo to `~/.config/nvim-dev`.
- LSPs/formatters are expected to come from the Nix build. There is no Mason-style installer flow here.
- Always test your changes against the built Neovim package. Do not stop after editing config files or checking that the flake evaluates.
- Preferred validation flow:
  - build the package with `nix build .#default`
  - run the built `nvim` binary on temporary fixture files that exercise the change
  - inspect actual Neovim runtime state instead of inferring from config
- Use sample files appropriate to the task. Filetype-specific changes should be tested with real files of that type. If the task is not filetype-specific, still open representative fixture files and verify the changed behavior in Neovim.
- For runtime checks, prefer assertions from inside Neovim such as: detected filetype, loaded plugins, active LSP clients, diagnostics, formatter/linter execution, buffer/window options, keymaps, and commands.
- For visual changes, do not assume the UI is correct from reading Lua. Run Neovim with fixture files and check the rendered result. Use a real terminal capture or Neovim UI inspection when needed, especially for statusline, winbar, signs, highlights, layout, or similar visual behavior.
- Do not make assumptions when behavior, package contents, binary names, filetypes, plugin APIs, or upstream requirements are unclear. Verify them.
- If something is unclear or may have changed upstream, research it online using primary sources such as official documentation, upstream plugin docs, Neovim docs, or source code before changing the config.
- Treat package names and executable names as separate things. Verify the actual binaries available inside the built Neovim environment.
