{ config, pkgs, ... }:
{
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  # Preserve Home Manager's PATH in Niri's systemd session.
  systemd.user.services.niri.enableDefaultPath = false;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd ${config.programs.niri.package}/bin/niri-session";
      user = "greeter";
    };
  };

  # A password login supplies PAM with the secret needed for the login keyring.
  # The former greetd initial_session bypassed password authentication.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.swaylock = { };
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.niri = {
      default = [ "gnome" "gtk" ];
      # Keep the working GTK file picker override.
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
  };
}
