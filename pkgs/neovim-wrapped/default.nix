{ pkgs ? import <nixpkgs> {}, ... }:

# This package wraps the existing neovim, allowing for custom configurations
# or plugins to be easily added.
pkgs.neovim.override {
  # You can add or override Neovim plugins and configurations here.
  # For example, to add a specific plugin:
  # vimAlias = "nvim";
  # configure = {
  #   packages.my-plugin = with pkgs.vimPlugins; {
  #     start = [
  #       "my-plugin-repo" # Replace with actual plugin name
  #     ];
  #   };
  #   customRC = ''
  #     lua require('my-plugin').setup()
  #   '';
  # };
}