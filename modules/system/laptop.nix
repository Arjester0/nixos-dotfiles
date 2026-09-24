{ pkgs, ... }:
{
  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
      "systemd.show_status=auto"
    ];
    blacklistedKernelModules = [ "nouveau" ];
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    # Your recent HDMI test worked with the proprietary kernel module.
    # Reconsider only after testing the exact driver, GPU mode, and hotplug path.
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.upower.enable = true;
  services.fwupd.enable = true;

  fonts.packages = with pkgs; [
    inter
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];
}
