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
        bind "Alt g" { NewPane "Float"; }

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
```

A few things to note:

**The `settings` block and `config.kdl` are duplicated intentionally** — home-manager's `settings` attrset doesn't support the full KDL keybind syntax, so the keybinds have to live in a raw `config.kdl`. The settings block is effectively overridden by the file. You can simplify by removing `settings` entirely and just keeping the `xdg.configFile."zellij/config.kdl"` approach.

**`Alt Shift l` locks zellij** — this passes all keypresses straight to whatever's running (useful if an app needs Alt combos that conflict).

**Workflow for a new project:**
```
Alt+t          → new tab
Alt+r → myproject → Enter   → rename it
Alt+|          → split right (now you have 2 panes)
Alt+-          → split the right pane down
Alt+g          → floating scratchpad for quick git stuff
Alt+Space      → fullscreen your editor when you need focus
Alt+d          → detach, close kitty — session survives
