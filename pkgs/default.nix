{ pkgs }:
{
  neovim-wrapped = pkgs.callPackage ./neovim-wrapped {};
  ecs-exec       = pkgs.callPackage ./ecs-exec {};
}
