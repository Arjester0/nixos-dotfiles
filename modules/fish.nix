{ ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
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

  programs.fish = {
    enable = true;
    generateCompletions = true;

    shellAliases = {
      ll = "eza -la";
      ls = "eza";
      cat = "bat";
      vi = "nvim";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#arjester";
      config = "cd ~/nixos-dotfiles/config";
      qs = "quickshot";
      jai = "steam-run ~/.local/bin/jai";
    };

    shellInit = ''
      set -gx HYPRSHOT_DIR "$HOME/Pictures/screenshots"
      set -gx EDITOR nvim
      fish_add_path -g "$HOME/.cargo/bin" "$HOME/.local/bin"
      set -g fish_greeting
    '';

    loginShellInit = ''
      if test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" = 1
        exec start-hyprland
      end
    '';
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}
