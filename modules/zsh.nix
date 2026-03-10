{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch.symbol = " ";
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # remove oh-my-zsh block entirely

    sessionVariables = {
      PATH = "$HOME/.cargo/bin:$PATH";
      HYPRSHOT_DIR = "$HOME/Pictures/screenshots";
      EDITOR = "nvim";
    };

    shellAliases = {
      ll = "ls -l";
      vi = "nvim";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#arjester";
      config = "cd ~/nixos-dotfiles/config";
      qs = "quickshot";
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = [ "rm *" "pkill *" "cp *" ];

    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec hyprland
      fi
    '';
    initContent = ''
      fastfetch
    '';
  };

  programs.fzf.enable = true;
}
