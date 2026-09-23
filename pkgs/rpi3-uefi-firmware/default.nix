{ stdenvNoCC, fetchzip, lib, ... }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rpi3-uefi-firmware";
  version = "1.53.1";

  src = fetchzip {
    url = "https://github.com/pftf/RPi3/releases/download/v${finalAttrs.version}/RPi3_UEFI_Firmware_v${finalAttrs.version}.zip";
    hash = "sha256-ljlKR90aqZfmnISFfTJMxQaq/ixQGWOASdPzKU5xuGA=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r ./* $out/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/pftf/RPi3";
    description = "Raspberry Pi 3 UEFI Firmware Images";
    license = licenses.bsd2Patent;
    platforms = platforms.all;
  };
})
