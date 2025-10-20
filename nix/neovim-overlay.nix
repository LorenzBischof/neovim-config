# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.

{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin =
    src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  codesettings = pkgs.vimUtils.buildVimPlugin {
    name = "codesettings-nvim";
    src = pkgs.fetchFromGitHub {
      repo = "codesettings.nvim";
      #owner = "mrjones2014";
      #rev = "d1b18b502e0ae8c9b9336a239f8cc18021968fb1";
      #hash = "sha256-6IYxoXgF26Jzc8r1Gv8UsNBn3swth+wDS604lXveLgQ=";
      owner = "lorenzbischof";
      rev = "35cb32bd75d6478eb72b0218df71c78c05e15238";
      hash = "sha256-VOrI1ipy0MRqp6CObFzQ1Kr/U4/9BaW7qnVfXFQ5GqA=";
    };
  };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
  };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins

    # Seems to impact startup performance
    #nvim-treesitter.withAllGrammars
    (nvim-treesitter.withPlugins (
      p: with p; [
        bash
        go
        rust
        lua
        nix
        python
        typescript
      ]
    ))
    luasnip # snippets | https://github.com/l3mon4d3/luasnip/
    vim-beancount
    nvim-lspconfig
    # git integration plugins
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    # telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim
    # ^ telescope and extensions
    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    # ^ UI
    # language support
    rustaceanvim
    lsp-progress-nvim
    # ^ language support
    # navigation/editing enhancement plugins
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    vim-sleuth
    {
      plugin = avante-nvim;
      optional = true;
    }
    # ^ navigation/editing enhancement plugins
    # debugging
    nvim-dap
    nvim-dap-go
    nvim-dap-rego
    nvim-dap-virtual-text
    nvim-dap-ui
    # ^ debugging
    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    nvim-lint
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    lz-n
    # ^ libraries that other plugins depend on
    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    # ^ bleeding-edge plugins from flake inputs
    which-key-nvim
    base16-nvim
    conform-nvim
    lazydev-nvim
    indent-blankline-nvim
    vim-illuminate
    codesettings
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server
    nixd
    delve
    beancount
    nixfmt-rfc-style
    rust-analyzer
    regal
  ];

  extraPython3Packages = p: [
    p.regex # This is required by the beancount omni completion
  ];
in
{
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages extraPython3Packages;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages extraPython3Packages;
    appName = "nvim-dev";
    wrapRc = false;
  };
}
