{
  config,
  lib,
  pkgs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";

  mkOutOfStoreSymlink = path: config.lib.file.mkOutOfStoreSymlink path;

  /*
    These directories remain manually editable in:

      ~/nixos-dotfiles/config/<name>

    Home Manager creates links from ~/.config/<name>.

    Do not also configure the same application with a Home Manager
    module that writes files under ~/.config/<name>, unless that module
    is configured not to generate those files.
  */
  linkedConfigs = {
    niri = "niri";
    rofi = "rofi";
    waybar = "waybar";
    mako = "mako";
    cava = "cava";
    quickshell = "quickshell";
    scripts = "scripts";
    wallust = "wallust";
    qt5ct = "qt5ct";
    qt6ct = "qt6ct";
  };
in
{
  imports = [
    ./cursor.nix
    ./direnv.nix
    ./helix.nix
    ./nushell.nix
    ./zellij.nix
    ./niri.nix
    ./ghostty.nix
  ];

  # --------------------------------------------------------------
  # Home Manager
  # --------------------------------------------------------------

  home = {
    username = "arjester";
    homeDirectory = "/home/arjester";
    stateVersion = "25.05";

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      TERMINAL = "ghostty";
      BROWSER = "brave";

      GTK_THEME = "adw-gtk3-dark";
      GTK_ICON_THEME = "Papirus-Dark";

      QT_QPA_PLATFORM = "wayland;xcb";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "adwaita-dark";

      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    packages = with pkgs; [
      # ----------------------------------------------------------
      # NCC-style command-line toolkit
      # ----------------------------------------------------------

      bat
      bottom
      btop
      choose
      curl
      delta
      doggo
      dust
      eza
      fd
      fzf
      hyperfine
      jq
      ouch
      procs
      ripgrep
      sd
      tealdeer
      tokei
      tree
      unzip
      wget
      xh
      yazi
      zip

      # ----------------------------------------------------------
      # Version control
      # ----------------------------------------------------------

      gh
      jujutsu
      lazygit

      # ----------------------------------------------------------
      # Nix tools
      # ----------------------------------------------------------

      deadnix
      nil
      nixd
      nixfmt-rfc-style
      statix

      # ----------------------------------------------------------
      # Wayland desktop utilities
      # ----------------------------------------------------------

      brightnessctl
      grim
      libnotify
      pamixer
      playerctl
      slurp
      swaybg
      swayidle
      swaylock
      wev
      wl-clipboard

      # Applications configured through linked dotfiles
      cava
      quickshell
      rofi
      waybar

      # ----------------------------------------------------------
      # Themes and toolkit configuration
      # ----------------------------------------------------------

      adw-gtk3
      adwaita-qt
      papirus-icon-theme

      libsForQt5.qt5ct
      qt6Packages.qt6ct
    ];
  };

  programs.home-manager.enable = true;

  # --------------------------------------------------------------
  # Editable out-of-store configuration links
  # --------------------------------------------------------------

  xdg = {
    enable = true;

    configFile = lib.mapAttrs (_name: subpath: {
      source = mkOutOfStoreSymlink "${dotfiles}/${subpath}";
      recursive = true;
      force = true;
    }) linkedConfigs;

    mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = [ "brave-browser.desktop" ];
        "text/xml" = [ "brave-browser.desktop" ];
        "application/xhtml+xml" = [ "brave-browser.desktop" ];

        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
        "x-scheme-handler/about" = [ "brave-browser.desktop" ];
        "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # --------------------------------------------------------------
  # Git and version-control tools
  # --------------------------------------------------------------

  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";

      core = {
        editor = "hx";
        autocrlf = "input";
      };

      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;

      rerere.enabled = true;

      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };

      merge.conflictStyle = "zdiff3";
    };

    ignores = [
      ".direnv/"
      ".envrc.local"
      ".DS_Store"
      "*.swp"
      "*.swo"
      "*~"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = false;
      syntax-theme = "gruvbox-dark";
    };
  };

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.lazygit = {
    enable = true;

    settings = {
      gui = {
        nerdFontsVersion = "3";
        showRandomTip = false;
      };

      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };

  # --------------------------------------------------------------
  # Modern command-line programs
  # --------------------------------------------------------------

  programs.bat = {
    enable = true;

    config = {
      theme = "gruvbox-dark";
      style = "numbers,changes,header";
      pager = "less -FR";
    };
  };

  programs.btop = {
    enable = true;

    settings = {
      vim_keys = true;
      rounded_corners = true;
      proc_tree = true;
      update_ms = 1000;
    };
  };

  programs.eza = {
    enable = true;
    enableNushellIntegration = true;

    icons = "auto";
    git = true;

    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.fzf = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;

    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/*"
    ];
  };

  programs.tealdeer = {
    enable = true;

    settings = {
      updates.auto_update = true;
    };
  };

  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };

      preview = {
        wrap = "yes";
        tab_size = 2;
      };
    };
  };

  # --------------------------------------------------------------
  # Nushell integrations
  # --------------------------------------------------------------

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;

    # Retain normal `cd` while providing `z` for ranked navigation.
    options = [
      "--cmd"
      "z"
    ];
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;

    settings = {
      add_newline = false;
      command_timeout = 1000;

      character = {
        success_symbol = "[❯](bold cyan)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold cyan)";
      };

      directory = {
        truncation_length = 4;
        truncate_to_repo = false;
      };

      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      };

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$name]($style) ";
      };
    };
  };

  # --------------------------------------------------------------
  # GTK
  # --------------------------------------------------------------

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
  };

  # --------------------------------------------------------------
  # Qt
  # --------------------------------------------------------------

  qt = {
    enable = true;

    platformTheme.name = "qt5ct";

    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
