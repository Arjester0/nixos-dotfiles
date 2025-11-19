# hosts/lenovo/default.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    # ./home.nix   # if you wire Home Manager here
  ];

  networking.hostName = "arjester";
  # …
}

