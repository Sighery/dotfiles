{ lib, ... }:

let
  edp1-fingerprint = "00ffffffffffff0030e464070000000000200104952213780238d5975e598e271c5054000000010101010101010101010101010101012e3680a070381f403020350058c21000001a582b80a070381f403020350058c21000001a000000fe004d39375946803135365746430a000000000000413199001000000a010a202000a7";
  edp1-config = {
    crtc = 0;
    mode = "1920x1080";
    rate = "60.02";
  };

  work-hdmi1-fingerprint = "00ffffffffffff0026cdaa61790b00003323010380351e782a8b25aa534fa3250d5054b76b00d1c081809500b30081407140950f81c0023a801871382d40582c45000f282100001e000000ff0031323631383535313032393337000000fc00504c3234393248530a20202020000000fd0030781e8c1c000a202020202020015f020327f14b901f051404130312021101230907018301000065030c001000681a000001003078e62a4480a070382740302035000f28210000188a4d80a070382c40302035000f282100001e745980a070381440302035000f2821000018406b80a070381440302035000f282100001e000000000000000000000000000000000b";
  work-hdmi1-config = {
    crtc = 1;
    mode = "1920x1080";
    rate = "60.0";
  };

  work-hdmi2-fingerprint = "00ffffffffffff0026cdaa61410a00003323010380351e782a8b25aa534fa3250d5054b76b00d1c081809500b30081407140950f81c0023a801871382d40582c45000f282100001e000000ff0031323631383535313032363235000000fc00504c3234393248530a20202020000000fd0030781e8c1c000a202020202020019e020327f14b901f051404130312021101230907018301000065030c001000681a000001003078e62a4480a070382740302035000f28210000188a4d80a070382c40302035000f282100001e745980a070381440302035000f2821000018406b80a070381440302035000f282100001e000000000000000000000000000000000b";
  work-hdmi2-config = {
    crtc = 2;
    mode = "1920x1080";
    rate = "60.0";
  };
in
{
  programs.autorandr = {
    enable = true;

    profiles.standalone = {
      fingerprint = {
        "eDP-1" = edp1-fingerprint;
      };

      config = {
        "eDP-1" = lib.recursiveUpdate edp1-config {
          enable = true;
          position = "0x0";
          primary = true;
        };

        "DP-1-1".enable = false;
        "DP-1-2".enable = false;
      };
    };

    profiles.work = {
      fingerprint = {
        "eDP-1" = edp1-fingerprint;
        "DP-1-1" = work-hdmi1-fingerprint;
        "DP-1-2" = work-hdmi2-fingerprint;
      };

      config = {
        "DP-1-1" = lib.recursiveUpdate work-hdmi1-config {
          enable = true;
          position = "0x0";
        };

        "DP-1-2" = lib.recursiveUpdate work-hdmi2-config {
          enable = true;
          position = "1920x0";
        };

        "eDP-1" = lib.recursiveUpdate edp1-config {
          enable = true;
          position = "3840x0";
          primary = true;
        };
      };
    };
  };

  services.autorandr = {
    enable = true;
    ignoreLid = true;
    matchEdid = true;
  };
}
