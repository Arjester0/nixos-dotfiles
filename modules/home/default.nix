{ pkgs, ... }:
{
  imports = [
    ./cursor.nix
    ./direnv.nix
    ./helix.nix
    ./nushell.nix
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

      PAGER = "less -FR";
    };

    # Programs enabled with `programs.*` below install their own packages.
    packages = with pkgs; [
      bottom choose curl doggo dust fd hyperfine jq ouch procs sd tokei
      tree unzip wget xh zip jujutsu deadnix statix
      grim playerctl slurp swayidle wev wl-clipboard
      brightnessctl libnotify pamixer swaybg swaylock
      cava quickshell rofi waybar mako xwayland-satellite
      pavucontrol
      brave zathura nautilus obs-studio qbittorrent emacs
      # Shared by Emacs, Helix, and project shells; nixfmt is the sole Nix formatter.
      basedpyright bash-language-server clang-tools deno gopls
      lua-language-server marksman nixd nixfmt ruff rust-analyzer
      taplo texlab yaml-language-server
      libsForQt5.qt5ct qt6Packages.qt6ct
    ];
  };

  programs.home-manager.enable = true;

  # Rofi, Waybar, Mako, Cava, Quickshell, etc. are regular editable
  # files in ~/.config; Home Manager does not claim or overwrite them.
  xdg = {
    enable = true;
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
    enableNushellIntegration = false;

    icons = "auto";
    git = true;

    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.fzf.enable = true;

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
