{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # .config/directory
  configs = {
    nvim = "nvim";
    niri = "niri";
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
    ./fish.nix
    ./cursor.nix
    ./direnv.nix
    ./zellij.nix
    ./helix.nix
  ];
  home.username = "arjester";
  home.homeDirectory = "/home/arjester";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  programs.git.enable = true;
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "text/xml" = "brave-browser.desktop";
      "application/xhtml+xml" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
    force = true;
  }) configs;

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Inter";
      size = 10;
    };
    gtk2.extraConfig = ''
      gtk-toolbar-style=GTK_TOOLBAR_ICONS
      gtk-button-images=0
      gtk-menu-images=1
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:minimize,maximize,close";
      gtk-button-images = false;
      gtk-menu-images = true;
      gtk-toolbar-style = "icons";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:minimize,maximize,close";
    };
    gtk4.theme = config.gtk.theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
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
    adw-gtk3
    papirus-icon-theme
    bibata-cursors
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    adwaita-qt
  ];
}
