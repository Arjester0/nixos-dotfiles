{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "gruvbox-dark";
      default_layout = "battlestation";
      pane_frames = false;
      mouse_mode = false;
      default_shell = "zsh";
      on_force_close = "detach";
      copy_on_select = false;
      simplified_ui = false;
    };
  };

  # Main config — keybinds live here because home-manager settings
  # doesn't support the full KDL keybind syntax yet
  xdg.configFile."zellij/config.kdl".text = ''
    theme "gruvbox-dark"
    default_layout "battlestation"
    pane_frames false
    mouse_mode false
    default_shell "zsh"
    on_force_close "detach"
    copy_on_select false

    keybinds clear-defaults=true {
      // --- NORMAL (always-on) mode ---
      // Pane focus: Alt + hjkl
      shared_except "locked" {
        bind "Alt h" { MoveFocus "Left"; }
        bind "Alt l" { MoveFocus "Right"; }
        bind "Alt k" { MoveFocus "Up"; }
        bind "Alt j" { MoveFocus "Down"; }

        // Pane split
        bind "Alt -" { NewPane "Down"; }
        bind "Alt |" { NewPane "Right"; }

        // Pane close
        bind "Alt x" { CloseFocus; }

        // Fullscreen toggle
        bind "Alt Space" { ToggleFocusFullscreen; }

        // Floating pane toggle
        bind "Alt f" { ToggleFloatingPanes; }
        bind "Alt F" { TogglePaneEmbedOrFloating; }

        // New floating pane (scratchpad)
        bind "Alt g" { NewFloatingPane; }

        // Tabs
        bind "Alt t" { NewTab; }
        bind "Alt [" { GoToPreviousTab; }
        bind "Alt ]" { GoToNextTab; }
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        bind "Alt 3" { GoToTab 3; }
        bind "Alt 4" { GoToTab 4; }
        bind "Alt 5" { GoToTab 5; }

        // Rename tab
        bind "Alt r" { SwitchToMode "RenameTab"; TabNameInput 0; }

        // Resize mode
        bind "Alt =" { Resize "Increase"; }
        bind "Alt _" { Resize "Decrease"; }

        // Session detach
        bind "Alt d" { Detach; }

        // Scroll
        bind "Alt u" { HalfPageScrollUp; }
        bind "Alt e" { HalfPageScrollDown; }

        // Lock zellij (pass all keys through to shell/app)
        bind "Alt Shift l" { SwitchToMode "Locked"; }
      }

      locked {
        // Unlock
        bind "Alt Shift l" { SwitchToMode "Normal"; }
      }

      renametab {
        bind "Enter" { SwitchToMode "Normal"; }
        bind "Esc" { UndoRenameTab; SwitchToMode "Normal"; }
      }
    }
  '';

  xdg.configFile."zellij/layouts/battlestation.kdl".text = ''
    layout {
      tab name="main" focus=true {
        pane split_direction="vertical" {
          pane size="30%"
          pane size="45%" focus=true
          pane size="25%"
        }
      }
      floating_panes {
        pane {
          x "10%"
          y "10%"
          width "80%"
          height "80%"
        }
      }
    }
  '';
}
