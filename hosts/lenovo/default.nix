# hosts/lenovo/default.nix
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./configuration.nix
  ];
}
