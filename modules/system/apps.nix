{ pkgs, ... }:
{
  programs = {
    firefox.enable = true;
    nix-ld.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    wireshark = {
      enable = true;
      dumpcap.enable = true;
      package = pkgs.wireshark;
    };
  };

  # Proton VPN needs its NixOS package and system integration.
  environment.systemPackages = with pkgs; [
    vim
    proton-vpn
  ];
}
