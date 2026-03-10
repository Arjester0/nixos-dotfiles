{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;  # auto-attaches to a session when opening kitty
    settings = {
      theme = "gruvbox-dark";
      default_layout = "battlestation";
      pane_frames = false;        # cleaner look, no titles on each pane
      mouse_mode = false;         # keyboard-driven like Ludwig
      default_shell = "zsh";
    };
  };

  xdg.configFile."zellij/layouts/battlestation.kdl".text = ''
    layout {
      tab name="main" focus=true {
        pane split_direction="vertical" {
          pane size="30%"
          pane size="45%" focus=true
          pane size="25%"
        }
      }
    }
  '';
}
