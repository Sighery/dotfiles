{ secrets, ... }:

{
  imports = [
    ../sighery-common/main.nix

    ./autorandr.nix
    ./i3.nix
  ];

  programs.vscodium.profiles.default.userSettings = {
    "window.zoomLevel" = 1;
  };

  programs.ssh.settings = secrets.sonar.work_git_ssh;
  programs.git.includes = [ secrets.sonar.work_git_git ];
}
