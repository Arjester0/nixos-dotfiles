# Arjester's NixOS configuration

## File ownership

| Location | Owns |
| --- | --- |
| `flake.nix` | One NixOS host and its Home Manager integration |
| `hosts/lenovo/default.nix` | Machine identity, network, user, and imports |
| `modules/system/` | Boot, GPU, laptop services, audio, login, portals, system applications |
| `modules/home/default.nix` | User applications, shared developer tools, GTK/Qt, Git, MIME defaults |
| `modules/home/*.nix` | Niri, Nushell, Helix, Ghostty, Direnv, cursor |
| `~/.config/{rofi,waybar,mako,cava,quickshell,wallust,qt5ct,qt6ct}` | Regular files you edit directly; Home Manager does not manage them |
| `~/nixos-dotfiles/config/scripts` | Your existing wallpaper and startup scripts; Niri still calls these |
| `~/.config/emacs` or `~/.emacs.d` | Your existing portable Emacs config; this tree only installs Emacs |

Fish is no longer imported or installed. Nushell keeps Starship and its aliases. `hx` stays your quick-edit command and maps `jk` from insert mode to normal mode. The optional `portable/vimrc` gives you `jk` and manual `Ctrl-N`/`Ctrl-P` completion using **only words in the current file**; copy it to `~/.vimrc` if you want that behavior. It is a normal editable file and also works on non-Nix systems. Helix 25.07 does not implement the word-completion setting in its master documentation, so this tree does not claim to enable that feature in Helix.

## Files from your machine that must be kept

This handoff cannot recreate `hosts/lenovo/hardware-configuration.nix`, `flake.lock`, your Emacs config, or the contents of `config/` because they were not supplied. Keep the originals in place. In particular, **never replace the hardware scan with one from another machine**. The flake evaluation will fail until `hosts/lenovo/hardware-configuration.nix` is present. Do not remove `config/scripts` while Niri refers to it.

## Apply

1. Make a copy of your existing `~/nixos-dotfiles` directory. Copy this tree into that directory, preserving its relative paths. Leave `flake.lock`, `hosts/lenovo/hardware-configuration.nix`, `config/`, and your Emacs config intact. The old `modules/home.nix`, `modules/fish.nix`, or similarly named old modules should be removed only after checking that nothing else imports them.
2. Check which of `~/.config/rofi`, `waybar`, `mako`, `cava`, `quickshell`, `wallust`, `qt5ct`, and `qt6ct` are Home Manager links. Retain the editable originals in `~/nixos-dotfiles/config/` while you switch. Once Home Manager has removed the links, copy the corresponding directories as **real directories** under `~/.config/`. Back up any existing real directories first; do not copy over them blindly. You can edit the new files directly, then restart the affected application. If you use wallpaper scripts, inspect their paths for references to the former links.
3. Flakes only include files tracked by Git. From `~/nixos-dotfiles`, add the new `.nix` files to Git (`git add flake.nix hosts/lenovo modules/system modules/home`, or the equivalent in `jj`) before checking the configuration.
4. Run `sudo nixos-rebuild dry-build --flake ~/nixos-dotfiles#arjester`. If it succeeds, use `sudo nixos-rebuild test --flake ~/nixos-dotfiles#arjester` and check your graphical session. Then use `sudo nixos-rebuild switch --flake ~/nixos-dotfiles#arjester`. A logout/login is needed to test the new greetd password flow and keyring unlocking. The `check-system`, `test-system`, and `rebuild` Nushell aliases map to these commands.
5. The speaker rule is loaded by the user WirePlumber service. After switching, run `systemctl --user restart wireplumber`, then test playback after an idle period.

## Checks for the unresolved hardware questions

- **Keyring:** Log in through tuigreet using your account password (the same password as the *login* keyring). If Brave still prompts, inspect `journalctl -b | rg 'gkr-pam|gnome-keyring'`. A keyring created with a different password will still need its password updated manually.
- **Brightness:** Run `brightnessctl -l`, `brightnessctl get`, then `brightnessctl set 5%+` from your login session; use `wev` to check whether the keys send `XF86MonBrightnessUp/Down`. The current Niri shortcuts already exist. A machine specific backlight choice requires the device names from these commands.
- **HDMI hotplug:** Run `niri msg outputs` before and after plugging in, and inspect `journalctl -b -k | rg -i 'nvidia|drm|hdmi'`. Keep `hardware.nvidia.open = false` for now because your recent test recovered HDMI with that driver. Whether this is a kernel driver, GPU wiring, or Niri hotplug problem cannot be determined from the configuration alone. `services.xserver.videoDrivers` selects the NixOS driver even for a Wayland session; PRIME X11 settings are not an automatic Niri repair.
- **Audio:** If disabling output suspension does not help, capture `wpctl status` before and after playback stops; the device profile or laptop amplifier may be the cause.
- **Niri:** Once installed, `niri validate --config ~/.config/niri/config.kdl` verifies the generated KDL.

## Why there is no `flake-parts`

`flake-parts` becomes useful when the *flake outputs themselves* need reusable modules, packages/dev shells across several systems, or shared `perSystem` logic. Here `flake.nix` defines one NixOS configuration in a few lines, and NixOS and Home Manager already provide the module systems for the rest of the tree. Adding `flake-parts` now would add a new input and a new level of indirection without simplifying this host. See [flake-parts: Introduction](https://flake.parts/) and [working with system](https://flake.parts/system).

## References

- [NixOS Niri integration and greetd](https://wiki.nixos.org/wiki/Niri/en)
- [NixOS Secret Service and PAM keyring unlocking](https://wiki.nixos.org/wiki/Secret_Service)
- [NixOS PipeWire idle output troubleshooting](https://wiki.nixos.org/wiki/PipeWire)
- [NixOS backlight diagnosis](https://wiki.nixos.org/wiki/Backlight)
- [Niri hybrid GPU FAQ](https://github.com/niri-wm/niri/wiki/FAQ)
- [Helix editor settings](https://docs.helix-editor.com/editor.html) and [language server feature filters](https://docs.helix-editor.com/languages.html)
