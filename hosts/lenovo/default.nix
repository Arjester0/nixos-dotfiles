{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/desktop.nix
    ../../modules/system/laptop.nix
    ../../modules/system/audio.nix
    ../../modules/system/apps.nix
  ];

  networking = {
    hostName = "arjester";
    networkmanager.enable = true;
  };
  time.timeZone = "America/Los_Angeles";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  users.users.arjester = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = [ "wheel" "wireshark" "networkmanager" ];
  };
  environment.shells = [ pkgs.nushell ];

  # Installed with NixOS 25.05; never change just to upgrade nixpkgs.
  system.stateVersion = "25.05";
}
