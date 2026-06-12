{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # .config/directory
  configs = {
    nvim = "nvim";
    hypr = "hypr";
    rofi = "rofi";
    waybar = "waybar";
    kitty = "kitty";
    tmux = "tmux";
    mako = "mako";
    cava = "cava";
    quickshell = "quickshell";
    ghostty = "ghostty";
    scripts = "scripts";
    wallust = "wallust";
    qt5ct = "qt5ct";
    qt6ct = "qt6ct";
  };
in

{
  imports = [
    ./zsh.nix
    ./cursor.nix
    ./direnv.nix
    ./zellij.nix
    ./helix.nix
  ];
  home.username = "arjester";
  home.homeDirectory = "/home/arjester";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    GTK_THEME = "Chicago95";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "gtk2";
  };

  programs.git.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
    force = true;
  }) configs;

  gtk = {
    enable = true;
    theme = {
      name = "Chicago95";
      package = pkgs.chicago95;
    };
    iconTheme = {
      name = "Chicago95";
      package = pkgs.chicago95;
    };
    font = {
      name = "Noto Sans CJK JP";
      size = 10;
    };
    gtk2.extraConfig = ''
      gtk-toolbar-style=GTK_TOOLBAR_BOTH
      gtk-button-images=1
      gtk-menu-images=1
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = false;
      gtk-decoration-layout = "menu:minimize,maximize,close";
      gtk-button-images = true;
      gtk-menu-images = true;
      gtk-toolbar-style = "both";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = false;
      gtk-decoration-layout = "menu:minimize,maximize,close";
    };
    gtk4.theme = config.gtk.theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style = {
      name = "gtk2";
      package = pkgs.libsForQt5.qtstyleplugins;
    };
  };

  home.packages = with pkgs; [
    neovim
    ripgrep
    nixpkgs-fmt
    gcc
    rofi
    eza
    bat
    fd
    jq
    tokei
    dust
    nixd
    nixfmt
    playerctl
    cava
    lazygit
    chicago95
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugins
    qt6Packages.qt6ct
    adwaita-qt
  ];
}
