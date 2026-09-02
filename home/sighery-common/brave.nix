{ config
, lib
, pkgs
, ...
}:

let
  mergeScript = pkgs.runCommand "brave-merge-prefs.sh" { } ''
    cp ${./brave-merge-prefs.sh} $out
    chmod +x $out
  '';
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;

    extensions = [
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
      { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # Tampermonkey
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
    ];

    commandLineArgs = [
      "--disable-features=AutofillSavePaymentMethods"
    ];
  };

  home.activation.mergeBraveSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${mergeScript} ${pkgs.jq}/bin/jq '${./Brave-Preferences.json}' '${config.home.homeDirectory}/.config/BraveSoftware/Brave-Browser/Default/Preferences'
  '';
}
