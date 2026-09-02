{ config, ... }:

{
  xdg.configFile."khal/config".text = ''
    [locale]
    timeformat = %H:%M
    dateformat = %Y-%m-%d
    longdateformat = %Y-%m-%d
    datetimeformat = %Y-%m-%d %H:%M
    longdatetimeformat = %Y-%m-%d %H:%M

    [calendars]
      [[home]]
        path = ${config.home.homeDirectory}/.calendars/home/
  '';
}
