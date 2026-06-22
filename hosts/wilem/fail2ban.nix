{ lib, pkgs, inputs, ... }:

let
  nginx-logpath = "/var/log/nginx/access.log";

  nginx-444-filter = pkgs.writeText "nginx-444" ''
    [Definition]
    failregex = ^<HOST>.+".+" 444 .+$
  '';
  nginx-ssh-probe-filter = pkgs.writeText "nginx-ssh-probe" ''
    [Definition]
    failregex = ^<HOST> - - .*SSH-2.0-Go
  '';
  nginx-ssl-handshake-filter = pkgs.writeText "nginx-ssl-handshake" ''
    [Definition]
    failregex = ^<HOST> - - .+? "(\\\w+){5,}
  '';
  nginx-404-filter = pkgs.writeText "nginx-404" ''
    [Definition]
    failregex = ^<HOST>.+?"(\w+) .*?" 404
  '';
in
{
  services.fail2ban = {
    enable = true;

    ignoreIP = inputs.dotfiles-secrets.wilem.fail2ban_ignoreips;

    extraPackages = with pkgs; [ ipset ];
    banaction = "iptables-ipset-proto6-allports";

    maxretry = 5;
    bantime = "24h";
    bantime-increment = {
      enable = true;
      maxtime = "168h"; # Max 1 week ban
      overalljails = true;
    };

    jails.sshd.settings = {
      maxretry = 10;
      bantime = "1h";
    };

    # Using pre-defined fail2ban nginx filters
    # NixOS Nginx config forwards error logs to journald, but access logs
    # stay in /var/log/nginx/access.log

    # Error log-based filters
    # https://github.com/fail2ban/fail2ban/blob/557e7eecf951049135dd52724b7f494096192177/config/filter.d/nginx-http-auth.conf
    jails.nginx-http-auth.settings = {
      enabled = true;
      filter = "nginx-http-auth";
      maxretry = 3;
      findtime = "6h";
      banaction = "iptables-multiport";
      port = "http,https";
    };

    # https://github.com/fail2ban/fail2ban/blob/557e7eecf951049135dd52724b7f494096192177/config/filter.d/nginx-forbidden.conf
    jails.nginx-forbidden.settings = {
      enabled = true;
      filter = "nginx-forbidden";
      banaction = "iptables-multiport";
      port = "http,https";
    };

    # https://github.com/fail2ban/fail2ban/blob/557e7eecf951049135dd52724b7f494096192177/config/filter.d/nginx-botsearch.conf
    jails.nginx-botsearch-error-log.settings = {
      enabled = true;
      filter = "nginx-botsearch";
      maxretry = 1;
      banaction = "iptables-multiport";
      port = "http,https";
    };

    # Access log-based filters
    # https://github.com/fail2ban/fail2ban/blob/557e7eecf951049135dd52724b7f494096192177/config/filter.d/nginx-bad-request.conf
    jails.nginx-bad-request.settings = {
      enabled = true;
      filter = "nginx-bad-request";
      backend = "auto";
      logpath = nginx-logpath;
      maxretry = 1;
      banaction = "iptables-multiport";
      port = "http,https";
    };

    # https://github.com/fail2ban/fail2ban/blob/557e7eecf951049135dd52724b7f494096192177/config/filter.d/nginx-botsearch.conf
    jails.nginx-botsearch.settings = {
      enabled = true;
      filter = "nginx-botsearch";
      backend = "auto";
      logpath = nginx-logpath;
      banaction = "iptables-multiport";
      port = "http,https";
    };

    jails.nginx-444.settings = {
      enabled = true;
      filter = "nginx-444";
      backend = "auto";
      logpath = nginx-logpath;
      maxretry = 1;
      banaction = "iptables-multiport";
      port = "http,https";
    };

    jails.nginx-ssh-probe.settings = {
      enabled = true;
      filter = "nginx-ssh-probe";
      backend = "auto";
      logpath = nginx-logpath;
      maxretry = 1;
      banaction = "iptables-multiport";
      port = "http,https";
    };

    jails.nginx-ssl-handshake.settings = {
      enabled = true;
      filter = "nginx-ssl-handshake";
      backend = "auto";
      logpath = nginx-logpath;
      maxretry = 1;
      banaction = "iptables-multiport";
      port = "http,https";
    };

    # This rule will trigger when over 10 404s happen within 10 seconds
    jails.nginx-404.settings = {
      enabled = true;
      filter = "nginx-404";
      backend = "auto";
      logpath = nginx-logpath;
      findtime = 10;
      maxretry = 10;
      banaction = "iptables-multiport";
      port = "http,https";
    };
  };

  environment.etc."fail2ban/filter.d/nginx-444.local".source = nginx-444-filter;
  environment.etc."fail2ban/filter.d/nginx-ssh-probe.local".source = nginx-ssh-probe-filter;
  environment.etc."fail2ban/filter.d/nginx-ssl-handshake.local".source = nginx-ssl-handshake-filter;
  environment.etc."fail2ban/filter.d/nginx-404.local".source = nginx-404-filter;
}
