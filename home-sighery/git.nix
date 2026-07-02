{ lib, osConfig, pkgs, inputs, ... }:

let
  hostname = osConfig.networking.hostName;
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    includes = [
      {
        contents = {
          init = {
            defaultBranch = "main";
          };

          core = {
            pager = "less -x1,5";
          };

          rerere = {
            enabled = "true";
          };

          status = {
            showUntrackedFiles = "all";
          };

          format = {
            pretty = "fuller";
          };
        };
      }
      {
        condition = "gitdir:~/Programming/";

        contents = {
          user = {
            email = inputs.dotfiles-secrets.git.github.personal_email;
            name = "Sighery";
            signingKey = "9454A24E1B5E963078B6E9317C02D10683ADCFB8";
          };

          commit = {
            gpgSign = "true";
          };
        };
      }
    ]
    ++ lib.optional (hostname == "sonar") inputs.dotfiles-secrets.sonar.work_git_git;
  };
}
