{ config, pkgs, ... }:
let
  zellijConfig = "${config.home.homeDirectory}/nixos-dotfiles/config/zellij";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
  };

  xdg.configFile."zellij/config.kdl" = {
    source = create_symlink "${zellijConfig}/config.kdl";
    force = true;
  };

  xdg.configFile."zellij/layouts/dev.kdl" = {
    source = create_symlink "${zellijConfig}/layouts/dev.kdl";
    force = true;
  };

  xdg.configFile."zellij/layouts/default.kdl" = {
    source = create_symlink "${zellijConfig}/layouts/default.kdl";
    force = true;
  };
}
