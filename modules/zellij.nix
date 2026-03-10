{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
  };

  xdg.configFile."zellij/config.kdl".text = ''
    theme "blue-archive"
    default_layout "battlestation"
    pane_frames false
    mouse_mode false
    default_shell "zsh"
    on_force_close "detach"
    copy_on_select false
    show_tab_bar = true
    tab_bar_at_bottom = false
    themes {
	blue-archive {
	  fg     "#C8D8F0"
	  bg     "#0D1B2A"
	  black  "#0D1B2A"
	  red    "#FF6B8A"
	  green  "#5DDBB0"
	  yellow "#FFD485"
	  blue   "#4DB8FF"
	  magenta "#B8A0FF"
	  cyan   "#7FE7F5"
	  white  "#E8F0FF"
	  orange "#FF9E6B"
	}
      }
    keybinds clear-defaults=true {
      shared_except "locked" {
        bind "Alt h" { MoveFocus "Left"; }
        bind "Alt l" { MoveFocus "Right"; }
        bind "Alt k" { MoveFocus "Up"; }
        bind "Alt j" { MoveFocus "Down"; }
        bind "Alt o" { Run "nvim" "/home/arjester/Downloads/obsidian/todo.txt" { floating true; x "15%"; y "10%"; width "70%"; height "80%"; }; SwitchToMode "Normal"; }
        bind "Alt ?" { Run "nvim" "/home/arjester/nixos-dotfiles/config/keybinds.txt" { floating true; x "5%"; y "5%"; width "90%"; height "90%"; }; SwitchToMode "Normal"; }
        bind "Alt -" { NewPane "Down"; }
        bind "Alt |" { NewPane "Right"; }
        bind "Alt x" { CloseFocus; }
        bind "Alt Space" { ToggleFocusFullscreen; }
        bind "Alt f" { ToggleFloatingPanes; }
        bind "Alt F" { TogglePaneEmbedOrFloating; }
        bind "Alt g" { Run "zsh" { floating true; x "10%"; y "10%"; width "80%"; height "80%"; }; SwitchToMode "Normal"; }
        bind "Alt t" { NewTab; }
        bind "Alt [" { GoToPreviousTab; }
        bind "Alt ]" { GoToNextTab; }
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        bind "Alt 3" { GoToTab 3; }
        bind "Alt 4" { GoToTab 4; }
        bind "Alt 5" { GoToTab 5; }
        bind "Alt r" { SwitchToMode "RenameTab"; TabNameInput 0; }
        bind "Alt =" { Resize "Increase"; }
        bind "Alt _" { Resize "Decrease"; }
        bind "Alt d" { Detach; }
        bind "Alt u" { HalfPageScrollUp; }
        bind "Alt e" { HalfPageScrollDown; }
        bind "Alt Shift l" { SwitchToMode "Locked"; }
      }
      locked {
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
        floating_panes {
          pane {
            x "10%"
            y "10%"
            width "80%"
            height "80%"
          }
        }
      }
    }
  '';

  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
      tab name="shell" focus=true {
        pane split_direction="vertical" {
          pane size="70%" focus=true
          pane size="30%"
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
    }
  '';
}
