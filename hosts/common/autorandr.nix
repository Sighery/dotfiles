{ ... }:

{
  # Udev rule to trigger home-manager's autorandr systemd service
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", \
      TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="autorandr.service"
  '';
}
