{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    fcitx5
    libnotify
    mako
    pamixer
    rofi
    swaybg
    swaylock
    waybar
    xwayland-satellite
    yazi
  ];

  xdg.configFile."niri/config.kdl".text = ''
    // ============================================================
    // Arjester Niri configuration
    // Current visual setup + NCC-style functionality
    // ============================================================

    // ------------------------------------------------------------
    // Startup
    // ------------------------------------------------------------

    // This locks the session immediately whenever Niri starts.
    // Remove this line if the login-time lock is not intentional.
    spawn-at-startup "swaylock" "-f"

    spawn-at-startup "bash" "-lc" "$HOME/nixos-dotfiles/config/scripts/start-swaybg.sh"
    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "fcitx5" "-d"

    // ------------------------------------------------------------
    // Environment
    // ------------------------------------------------------------

    environment {
        GTK_THEME "adw-gtk3-dark"
        GTK_ICON_THEME "Papirus-Dark"

        QT_QPA_PLATFORM "wayland;xcb"
        QT_QPA_PLATFORMTHEME "qt5ct"
        QT_STYLE_OVERRIDE "adwaita-dark"

        XCURSOR_SIZE "24"

        NIXOS_OZONE_WL "1"
        MOZ_ENABLE_WAYLAND "1"
        ELECTRON_OZONE_PLATFORM_HINT "auto"

        XDG_CURRENT_DESKTOP "niri"
        XDG_SESSION_DESKTOP "niri"
        XDG_SESSION_TYPE "wayland"
    }

    prefer-no-csd

    // Screenshot filenames used by the built-in screenshot actions.
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // ------------------------------------------------------------
    // Outputs
    // ------------------------------------------------------------

    output "eDP-1" {
        scale 1.5
    }

    output "HDMI-A-1" {
        scale 1.67
    }

    // ------------------------------------------------------------
    // Input
    // ------------------------------------------------------------

    input {
        keyboard {
            xkb {
                layout "us"
            }

            repeat-delay 200
            repeat-rate 35
        }

        touchpad {
            tap
        }

        mouse {
            accel-speed 0.0
        }

        // Keep focus under the pointer without causing large,
        // unexpected horizontal workspace scrolling.
        focus-follows-mouse max-scroll-amount="0%"
    }

    // ------------------------------------------------------------
    // Layout
    // ------------------------------------------------------------

    layout {
        gaps 0

        // NCC-style width cycling.
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        // Used by switch-preset-window-height.
        preset-window-heights {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width {
            proportion 0.5
        }

        center-focused-column "never"

        focus-ring {
            width 2
            active-color "#7fe7f5"
            inactive-color "#2a3240"
        }

        border {
            off
        }

        // Small tab indicator for tabbed columns.
        tab-indicator {
            hide-when-single-tab
        }
    }

    // Slight rounding while retaining your cyber-terminal appearance.
    window-rule {
        geometry-corner-radius 6
        clip-to-geometry true
    }

    // ------------------------------------------------------------
    // Keybindings
    // ------------------------------------------------------------

    binds {
        // ========================================================
        // Applications and session
        // ========================================================

        Mod+Return hotkey-overlay-title="Open Ghostty" {
            spawn "ghostty";
        }

        Mod+Q hotkey-overlay-title="Close Window" {
            close-window;
        }

        // Preserved from your configuration.
        // This immediately asks Niri to quit.
        Mod+M hotkey-overlay-title="Quit Niri" {
            quit;
        }

        // Use Ghostty instead of Kitty to match your terminal setup.
        Mod+E hotkey-overlay-title="Open Yazi" {
            spawn "ghostty" "-e" "nu" "-c" "yazi";
        }

        Mod+D hotkey-overlay-title="Application Launcher" {
            spawn "rofi" "-show" "drun";
        }

        Mod+B hotkey-overlay-title="Open Brave" {
            spawn "brave";
        }

        Mod+W hotkey-overlay-title="Change Wallpaper" {
            spawn "bash" "-lc" "$HOME/nixos-dotfiles/config/scripts/wallpaper.sh";
        }

        Mod+R hotkey-overlay-title="Restart Waybar" {
            spawn "bash" "-lc" "pkill waybar; waybar >/tmp/waybar.log 2>&1 &";
        }

        // NCC/default-style discoverability features.
        Mod+O hotkey-overlay-title="Toggle Overview" {
            toggle-overview;
        }

        Mod+Shift+Slash hotkey-overlay-title="Show Important Hotkeys" {
            show-hotkey-overlay;
        }

        // ========================================================
        // Screenshots
        // ========================================================

        // Preserve Mod+S as your region screenshot shortcut.
        Mod+S hotkey-overlay-title="Screenshot Selection" {
            screenshot;
        }

        Print hotkey-overlay-title="Screenshot Selection" {
            screenshot;
        }

        Ctrl+Print hotkey-overlay-title="Screenshot Output" {
            screenshot-screen;
        }

        Alt+Print hotkey-overlay-title="Screenshot Window" {
            screenshot-window;
        }

        // ========================================================
        // Floating, fullscreen and tabbed columns
        // ========================================================

        Mod+V hotkey-overlay-title="Toggle Floating" {
            toggle-window-floating;
        }

        Mod+Shift+V hotkey-overlay-title="Focus Floating or Tiling" {
            switch-focus-between-floating-and-tiling;
        }

        Mod+T hotkey-overlay-title="Toggle Tabbed Column" {
            toggle-column-tabbed-display;
        }

        Mod+F hotkey-overlay-title="Maximize Column" {
            maximize-column;
        }

        Mod+Shift+F hotkey-overlay-title="Toggle Fullscreen" {
            fullscreen-window;
        }

        // ========================================================
        // Focus navigation
        // ========================================================

        Mod+H hotkey-overlay-title="Focus Left" {
            focus-column-left;
        }

        Mod+L hotkey-overlay-title="Focus Right" {
            focus-column-right;
        }

        Mod+K hotkey-overlay-title="Focus Up" {
            focus-window-up;
        }

        Mod+J hotkey-overlay-title="Focus Down" {
            focus-window-down;
        }

        Mod+Home hotkey-overlay-title="Focus First Column" {
            focus-column-first;
        }

        Mod+End hotkey-overlay-title="Focus Last Column" {
            focus-column-last;
        }

        // Focus another monitor.
        Mod+Ctrl+Left hotkey-overlay-title="Focus Monitor Left" {
            focus-monitor-left;
        }

        Mod+Ctrl+Right hotkey-overlay-title="Focus Monitor Right" {
            focus-monitor-right;
        }

        Mod+Ctrl+Up hotkey-overlay-title="Focus Monitor Up" {
            focus-monitor-up;
        }

        Mod+Ctrl+Down hotkey-overlay-title="Focus Monitor Down" {
            focus-monitor-down;
        }

        // ========================================================
        // Move windows and columns
        // ========================================================

        // Preserve your Shift-based movement controls.
        Mod+Shift+H hotkey-overlay-title="Move Column Left" {
            move-column-left;
        }

        Mod+Shift+L hotkey-overlay-title="Move Column Right" {
            move-column-right;
        }

        Mod+Shift+K hotkey-overlay-title="Move Window Up" {
            move-window-up;
        }

        Mod+Shift+J hotkey-overlay-title="Move Window Down" {
            move-window-down;
        }

        Mod+Shift+Home hotkey-overlay-title="Move Column First" {
            move-column-to-first;
        }

        Mod+Shift+End hotkey-overlay-title="Move Column Last" {
            move-column-to-last;
        }

        // Move the active column to another monitor.
        Mod+Ctrl+Shift+Left hotkey-overlay-title="Move Column to Monitor Left" {
            move-column-to-monitor-left;
        }

        Mod+Ctrl+Shift+Right hotkey-overlay-title="Move Column to Monitor Right" {
            move-column-to-monitor-right;
        }

        Mod+Ctrl+Shift+Up hotkey-overlay-title="Move Column to Monitor Up" {
            move-column-to-monitor-up;
        }

        Mod+Ctrl+Shift+Down hotkey-overlay-title="Move Column to Monitor Down" {
            move-column-to-monitor-down;
        }

        // ========================================================
        // Column composition
        // ========================================================

        // Put the focused window into the neighboring column, or
        // expel it if it is already inside a multi-window column.
        Mod+BracketLeft hotkey-overlay-title="Consume or Expel Left" {
            consume-or-expel-window-left;
        }

        Mod+BracketRight hotkey-overlay-title="Consume or Expel Right" {
            consume-or-expel-window-right;
        }

        // Explicit alternatives.
        Mod+Comma hotkey-overlay-title="Consume Window into Column" {
            consume-window-into-column;
        }

        Mod+Period hotkey-overlay-title="Expel Window from Column" {
            expel-window-from-column;
        }

        // ========================================================
        // Sizing and positioning
        // ========================================================

        // Keep your existing manual sizing bindings.
        Mod+Alt+H hotkey-overlay-title="Decrease Column Width" {
            set-column-width "-10%";
        }

        Mod+Alt+L hotkey-overlay-title="Increase Column Width" {
            set-column-width "+10%";
        }

        Mod+Alt+K hotkey-overlay-title="Decrease Window Height" {
            set-window-height "-10%";
        }

        Mod+Alt+J hotkey-overlay-title="Increase Window Height" {
            set-window-height "+10%";
        }

        // NCC/default-style sizing controls.
        Mod+Minus hotkey-overlay-title="Decrease Column Width" {
            set-column-width "-10%";
        }

        Mod+Equal hotkey-overlay-title="Increase Column Width" {
            set-column-width "+10%";
        }

        Mod+Shift+Minus hotkey-overlay-title="Decrease Window Height" {
            set-window-height "-10%";
        }

        Mod+Shift+Equal hotkey-overlay-title="Increase Window Height" {
            set-window-height "+10%";
        }

        Mod+Ctrl+R hotkey-overlay-title="Cycle Column Width" {
            switch-preset-column-width;
        }

        Mod+Ctrl+Shift+R hotkey-overlay-title="Cycle Window Height" {
            switch-preset-window-height;
        }

        Mod+Ctrl+Backspace hotkey-overlay-title="Reset Window Height" {
            reset-window-height;
        }

        Mod+C hotkey-overlay-title="Center Column" {
            center-column;
        }

        Mod+Ctrl+C hotkey-overlay-title="Center Visible Columns" {
            center-visible-columns;
        }

        // ========================================================
        // Workspace focus
        // ========================================================

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+0 { focus-workspace 10; }

        Mod+Page_Down hotkey-overlay-title="Workspace Down" {
            focus-workspace-down;
        }

        Mod+Page_Up hotkey-overlay-title="Workspace Up" {
            focus-workspace-up;
        }

        Mod+Tab hotkey-overlay-title="Previous Workspace" {
            focus-workspace-previous;
        }

        // ========================================================
        // Move columns between workspaces
        // ========================================================

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+Shift+0 { move-column-to-workspace 10; }

        Mod+Ctrl+Page_Down hotkey-overlay-title="Move Column to Workspace Down" {
            move-column-to-workspace-down;
        }

        Mod+Ctrl+Page_Up hotkey-overlay-title="Move Column to Workspace Up" {
            move-column-to-workspace-up;
        }

        // Reorder the workspace itself rather than moving only a column.
        Mod+Alt+Page_Down hotkey-overlay-title="Move Workspace Down" {
            move-workspace-down;
        }

        Mod+Alt+Page_Up hotkey-overlay-title="Move Workspace Up" {
            move-workspace-up;
        }

        // ========================================================
        // Mouse wheel navigation
        // ========================================================

        Mod+WheelScrollDown cooldown-ms=150 {
            focus-workspace-down;
        }

        Mod+WheelScrollUp cooldown-ms=150 {
            focus-workspace-up;
        }

        Mod+Ctrl+WheelScrollDown cooldown-ms=150 {
            move-column-to-workspace-down;
        }

        Mod+Ctrl+WheelScrollUp cooldown-ms=150 {
            move-column-to-workspace-up;
        }

        Mod+WheelScrollRight {
            focus-column-right;
        }

        Mod+WheelScrollLeft {
            focus-column-left;
        }

        Mod+Ctrl+WheelScrollRight {
            move-column-right;
        }

        Mod+Ctrl+WheelScrollLeft {
            move-column-left;
        }

        // ========================================================
        // Locking and monitor power
        // ========================================================

        // Preserved: black lock screen without unlock indicator.
        Mod+Shift+P hotkey-overlay-title="Lock with Black Screen" {
            spawn "swaylock" "-c" "000000" "--no-unlock-indicator";
        }

        // NCC/default-style output power-off command.
        // Move the mouse or press a key to wake the displays.
        Mod+Alt+P hotkey-overlay-title="Power Off Displays" {
            power-off-monitors;
        }

        // ========================================================
        // Audio
        // ========================================================

        XF86AudioRaiseVolume allow-when-locked=true {
            spawn "bash" "-lc" "pamixer -i 5 && notify-send -h int:value:$(pamixer --get-volume) 'Volume' \"$(pamixer --get-volume)%\"";
        }

        XF86AudioLowerVolume allow-when-locked=true {
            spawn "bash" "-lc" "pamixer -d 5 && notify-send -h int:value:$(pamixer --get-volume) 'Volume' \"$(pamixer --get-volume)%\"";
        }

        XF86AudioMute allow-when-locked=true {
            spawn "bash" "-lc" "pamixer -t && notify-send 'Volume' \"$([ \"$(pamixer --get-mute)\" = true ] && echo Muted || echo \"$(pamixer --get-volume)%\")\"";
        }

        XF86AudioMicMute allow-when-locked=true {
            spawn "bash" "-lc" "pamixer --default-source -t && notify-send 'Microphone' \"$([ \"$(pamixer --default-source --get-mute)\" = true ] && echo Muted || echo Live)\"";
        }

        // ========================================================
        // Brightness
        // ========================================================

        // brightnessctl get reports a raw device value, not a percentage.
        // These commands extract the percentage from brightnessctl -m.

        XF86MonBrightnessUp allow-when-locked=true {
            spawn "bash" "-lc" "brightnessctl set 5%+; percent=$(brightnessctl -m | cut -d, -f4 | tr -d '%'); notify-send -h int:value:$percent 'Brightness' \"$percent%\"";
        }

        XF86MonBrightnessDown allow-when-locked=true {
            spawn "bash" "-lc" "brightnessctl set 5%-; percent=$(brightnessctl -m | cut -d, -f4 | tr -d '%'); notify-send -h int:value:$percent 'Brightness' \"$percent%\"";
        }
    }
  '';
}
