{ ... }:

{
  xsession.windowManager.i3.config.workspaceOutputAssign = [
    {
      workspace = "1";
      output = [ "eDP-1" ];
    }
    {
      workspace = "9";
      output = [ "eDP-1" ];
    }
    {
      workspace = "2";
      output = [ "DP-1-1" "eDP-1" ];
    }
    {
      workspace = "3";
      output = [ "DP-1-2" "eDP-1" ];
    }
  ];
}
