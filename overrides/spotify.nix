final: prev:
{
  spotify = prev.spotify.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ prev.zip prev.unzip ];

    postInstall =
      (old.postInstall or "")
      + ''
        ln -s ${final.spotify-adblock}/lib/libspotifyadblock.so $libdir
        sed -i "s:^Name=Spotify.*:Name=Spotify-adblock:" "$out/share/spotify/spotify.desktop"
        wrapProgram $out/bin/spotify \
          --set LD_PRELOAD "${final.spotify-adblock}/lib/libspotifyadblock.so"

        # Hide placeholder for advert banner
        ${prev.unzip}/bin/unzip -p $out/share/spotify/Apps/xpui.spa xpui-snapshot.js | sed 's/adsEnabled:\!0/adsEnabled:false/' > $out/share/spotify/Apps/xpui-snapshot.js
        ${prev.zip}/bin/zip --junk-paths --update $out/share/spotify/Apps/xpui.spa $out/share/spotify/Apps/xpui-snapshot.js
        rm $out/share/spotify/Apps/xpui-snapshot.js
      '';
  });
}
