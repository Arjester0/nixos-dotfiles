{ ... }:
{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    # Test for the speakers going silent after a few seconds of inactivity.
    # Restrict this to ALSA output nodes; remove if the problem persists.
    wireplumber.extraConfig."99-speaker-idle" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~alsa_output.*"; } ];
          actions.update-props."session.suspend-timeout-seconds" = 0;
        }
      ];
    };
  };
}
