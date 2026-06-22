{ pkgs, config, lib, inputs, ... }:

let
  nginx-301-redirects = pkgs.writeText "nginx-301-redirects.conf" ''
    location = /code/JavaScript/PaginationTop.meta.js {
      return 301 https://github.com/Sighery/Scripts/raw/refs/heads/master/PaginationTop.meta.js;
    }
    location = /code/JavaScript/PaginationTop.user.js {
      return 301 https://github.com/Sighery/Scripts/raw/refs/heads/master/PaginationTop.user.js;
    }
    location = /code/JavaScript/RaChartEnhancer.meta.js {
      return 301 https://github.com/Sighery/RaChart/raw/refs/heads/master/RaChart%20Enhancer/RaChartEnhancer.meta.js;
    }
    location = /code/JavaScript/RaChartEnhancer.user.js {
      return 301 https://github.com/Sighery/RaChart/raw/refs/heads/master/RaChart%20Enhancer/RaChartEnhancer.user.js;
    }
  '';

  nginx-forbidden-maps = pkgs.writeText "nginx-forbidden-maps.conf" ''
    map $request_uri $is_attack_req {
      default 0;

      "/nginx.conf" 1;
      "/SDK/webLanguage" 1;
      "/actuator/health" 1;
      "/index.php" 1;
      "/public/index.php" 1;
      "/authenticate.leano" 1;
      "/info.php" 1;
      "/phpinfo.php" 1;
      "/config.json" 1;
      "/telescope/requests" 1;
      "/server-status" 1;
      "/Dr0v" 1;
      "/login" 1;
      "/wp-config.txt" 1;
      "/config.js" 1;
      "/dump.zip" 1;
      "/backup.tar.gz" 1;
      "/mailer.zip" 1;
      "/web.zip" 1;
      "/backup.sql.gz" 1;
      "/www.zip" 1;
      "/sendgrid_backup.zip" 1;
      "/smtp.zip" 1;
      "/sendgrid.zip" 1;
      "/sendgrid_export.zip" 1;
      "/db.sql.gz" 1;
      "/exports/sendgrid.zip" 1;
      "/site.zip" 1;
      "/sendgrid-backup.zip" 1;
      "/sendgrid-export.zip" 1;
      "/backup.zip" 1;
      "/backup/sendgrid.zip" 1;
      "/dump.sql.gz" 1;
      "/db.zip" 1;
      "/mail.zip" 1;
      "/email.zip" 1;
      "/sendgrid-config.zip" 1;
      "/images/images/cache.php" 1;

      "~^/\.env" 1;
      "~^/\.cache" 1;
      "~^/GponForm/" 1;
      "~^/cgi-bin/" 1;
      "~^/\.aws/" 1;
      "~^/\.docker/" 1;
      "~^/\.git/" 1;
      "~^/\+CSCOE\+/" 1;
      "~^/onvif/device_service" 1;
      "~^/workspace/drupal" 1;
      "~^/phpunit/" 1;
      "~^/wordpress/" 1;
      "~^/wp-json/" 1;
      "~^/wp-content/" 1;
      "~^/wp/" 1;
      "~^/cpanel" 1;

      "~*/vendor/phpunit/" 1;
      "~*/wp-includes/" 1;
      "~*xmlrpc\.php" 1;
      "~*/credentials\.json" 1;
    }

    map $uri $is_attack_req2 {
      default 0;

      "/bin/sh" 1;
    }

    map $args $is_attack_params {
      default 0;
      "~*(^|&)XDEBUG_SESSION_START=phpstorm(&|$)" 1;
      "~*allow_url_include(?:=|&|$)" 1;
    }

    map $request_method $is_attack_method {
      default 1;
      "GET" 0;
      "HEAD" 0;
    }

    map "$is_attack_req:$is_attack_req2:$is_attack_params" $block_request {
      default 0;
      "~*1" 1;
    }
  '';
in
{
  systemd.tmpfiles.settings."10-rincon" = {
    "/var/www/rincon" = {
      d = {
        user = "rincon";
        group = "rincon";
        mode = "0755";
      };
    };
  };

  # To add new passwords: nix-shell --packages apacheHttpd --run 'htpasswd -B -c FILENAME USERNAME'
  sops.secrets."nginx/analytics-subdomain/http-auth" = {
    mode = "0400";
    owner = config.users.users.nginx.name;
  };

  services.nginx = {
    enable = true;

    appendHttpConfig = ''
      log_format domains '$remote_addr - $remote_user [$time_local] '
                         '$host:$server_port '
                         '"$request" $status $body_bytes_sent '
                         '"$http_referer" "$http_user_agent" "$gzip_ratio"';
      access_log /var/log/nginx/access.log domains;

      include ${nginx-forbidden-maps};
    '';

    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedBrotliSettings = true;

    virtualHosts."sighery.com" = {
      onlySSL = true;
      useACMEHost = "sighery.com";
      root = "/var/www/rincon";
      default = true;

      extraConfig = ''
        include ${nginx-301-redirects};
        if ($is_attack_method) { return 444; }
        if ($block_request) { return 444; }
      '';
    };

    virtualHosts."www.sighery.com" = {
      onlySSL = true;
      useACMEHost = "sighery.com";

      extraConfig = ''
        include ${nginx-301-redirects};
        if ($is_attack_method) { return 444; }
        if ($block_request) { return 444; }

        location / {
          return 301 https://sighery.com$request_uri;
        }
      '';
    };

    virtualHosts."analytics.sighery.com" = {
      onlySSL = true;
      useACMEHost = "sighery.com";
      basicAuthFile = config.sops.secrets."nginx/analytics-subdomain/http-auth".path;

      extraConfig = ''
        if ($block_request) { return 444; }

        location / {
          alias /var/www/goaccess/;
          add_header Cache-Control 'private no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
          if_modified_since off;
          expires off;
          etag off;
        }

        location /ws {
          proxy_pass http://127.0.0.1:7890;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        }
      '';
    };

    # forceSSL auto-blocks won't let me add custom extra includes for blocking
    virtualHosts."sighery.com-http" = {
      listen = [
        { addr = "0.0.0.0"; port = 80; }
        { addr = "[::0]"; port = 80; }
      ];
      default = true;
      serverName = "sighery.com";

      extraConfig = ''
        include ${nginx-301-redirects};
        if ($is_attack_method) { return 444; }
        if ($block_request) { return 444; }

        location / {
          return 301 https://$host$request_uri;
        }
      '';
    };

    virtualHosts."www.sighery.com-http" = {
      listen = [
        { addr = "0.0.0.0"; port = 80; }
        { addr = "[::0]"; port = 80; }
      ];
      serverName = "www.sighery.com";

      extraConfig = ''
        include ${nginx-301-redirects};
        if ($is_attack_method) { return 444; }
        if ($block_request) { return 444; }

        location / {
          return 301 https://sighery.com$request_uri;
        }
      '';
    };

    virtualHosts."analytics.sighery.com-http" = {
      listen = [
        { addr = "0.0.0.0"; port = 80; }
        { addr = "[::0]"; port = 80; }
      ];
      serverName = "analytics.sighery.com";

      extraConfig = ''
        if ($block_request) { return 444; }

        location / {
          return 301 https://$host$request_uri;
        }
      '';
    };
  };


  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.goaccess = {
    enable = true;
    logFilePath = "/var/log/nginx/access.log";
    # When using a custom log format seems I also need to add date and time formats?
    logFormatCustom = ''%h %^[%d:%t %^] %v:%^ "%r" %s %b "%R" "%u"'';
    extraFlags = {
      date-format = "%d/%b/%Y";
      time-format = "%T";
    };

    geoipDbPaths = [
      "${pkgs.dbip-asn-lite}/share/dbip/dbip-asn-lite.mmdb"
      "${pkgs.dbip-country-lite}/share/dbip/dbip-country-lite.mmdb"
      "${pkgs.dbip-city-lite}/share/dbip/dbip-city-lite.mmdb"
    ];

    serverHost = "analytics.sighery.com";

    enableNginx = false;
  };

  sops.secrets."${inputs.dotfiles-secrets.wilem.acme.provider}/api-key" = {
    mode = "0400";
    owner = config.users.users.acme.name;
  };
  sops.secrets."${inputs.dotfiles-secrets.wilem.acme.provider}/api-secret" = {
    mode = "0400";
    owner = config.users.users.acme.name;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = inputs.dotfiles-secrets.wilem.acme.email;

    certs."sighery.com" = {
      domain = "sighery.com";
      extraDomainNames = [
        "www.sighery.com"
        "analytics.sighery.com"
      ];
      dnsProvider = inputs.dotfiles-secrets.wilem.acme.provider;
      credentialFiles = {
        "${lib.toUpper inputs.dotfiles-secrets.wilem.acme.provider}_API_KEY_FILE" =
          config.sops.secrets."${inputs.dotfiles-secrets.wilem.acme.provider}/api-key".path;
        "${lib.toUpper inputs.dotfiles-secrets.wilem.acme.provider}_API_SECRET_FILE" =
          config.sops.secrets."${inputs.dotfiles-secrets.wilem.acme.provider}/api-secret".path;
      };
      dnsPropagationCheck = true;
    };
  };

  users.users.nginx.extraGroups = [
    "acme"
    "rincon"
    "goaccess"
  ];
}
