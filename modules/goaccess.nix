# From: https://abhinavsarkar.net/notes/2025-goaccess-server-on-nixos/

{ config, lib, pkgs, ... }:

let
  serviceName = "goaccess";
  cfg = config.services."${serviceName}";
  nginxCfg = config.services.nginx;
  userName = cfg.userName;
  types = lib.types;
in
{
  options.services."${serviceName}" = {
    enable = lib.mkEnableOption "${serviceName} service";

    package = lib.mkOption {
      type = types.package;
      default = pkgs.goaccess;
      description = "The Goaccess package.";
    };

    userName = lib.mkOption {
      type = types.nonEmptyStr;
      default = serviceName;
      description = "The username to use for running the Goaccess service.";
    };

    dataDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/${userName}";
      description = "The directory in which the Goaccess data is saved.";
    };

    dataRetentionDays = lib.mkOption {
      type = types.int;
      default = 7;
      description = "The number of days for which the Goaccess server retains the report data.";
    };

    reportDir = lib.mkOption {
      type = types.path;
      default = "/var/www/${userName}";
      description = "The directory in which the Goaccess report file is saved.";
    };

    host = lib.mkOption {
      type = types.nonEmptyStr;
      default = "127.0.0.1";
      description = "The host to run the Goaccess server on.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 7890;
      description = "The port to run the Goaccess server on.";
    };

    logFilePath = lib.mkOption {
      type = types.path;
      description = "The full path to the log file to analyze.";
    };

    logFileFormat = lib.mkOption {
      type = types.nullOr (types.enum [
        "COMBINED"
        "VCOMBINED"
        "COMMON"
        "VCOMMON"
        "W3C"
        "SQUID"
        "CLOUDFRONT"
        "CLOUDSTORAGE"
        "AWSELB"
        "AWSS3"
        "AWSALB"
        "CADDY"
        "TRAEFIKCLF"
      ]);
      default = null;
      description = "The format of the log file to analyze.";
    };

    logFormatCustom = lib.mkOption {
      type = types.nullOr types.nonEmptyStr;
      default = null;
      description = ''
        Custom log format.
        You can check existing log formats here: <https://github.com/allinurl/goaccess/blob/4de199e9ebd8fdc14441b571fdb15d5ff980388b/src/settings.c#L69-L91>
      '';
    };

    geoipDbPaths = lib.mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = "List of GeoIP databases to use in Goaccess.";
    };

    extraFlags = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Custom extra configuration when executing goaccess.
        You can check config options here: <https://github.com/allinurl/goaccess/blob/master/config/goaccess.conf>
      '';
    };

    reportTitle = lib.mkOption {
      type = types.nullOr types.nonEmptyStr;
      default = null;
      description = "The title of the report webpage.";
    };

    enableNginx = lib.mkEnableOption ''
      Nginx as the reverse proxy for the Goaccess server. If enabled, an Nginx virtual host will
      be created for access to the Goaccess server'';

    nginxEnableSSL = lib.mkEnableOption "SSL for the Nginx reverse proxy";

    nginxACMEHost = lib.mkOption {
      type = types.nullOr types.nonEmptyStr;
      description = "Use existing ACME Host in Nginx configuration.";
    };

    nginxBasicAuthFile = lib.mkOption {
      type = types.nullOr types.path;
      description = "Nginx HTTP Basic Auth file path.";
    };

    serverHost = lib.mkOption {
      type = types.nonEmptyStr;
      description = "The full public domain of the Goaccess server.";
    };

    serverPath = lib.mkOption {
      type = types.str;
      default = "";
      description = "The path component URL of the Goaccess server. Must be an empty string or end with '/'.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.serverPath == "" || lib.strings.hasSuffix "/" cfg.serverPath;
        message = "The serverPath option is neither an empty string, nor ends with '/'.";
      }
      {
        assertion = cfg.logFileFormat == null || cfg.logFormatCustom == null;
        message = "Either logFileFormat or logFormatCustom must be set.";
      }
    ];

    users.users.${userName} = {
      isSystemUser = true;
      group = userName;
      home = cfg.dataDir;
      createHome = true;
      extraGroups = lib.optional (cfg.logFilePath == "/var/log/nginx/access.log") nginxCfg.group;
    };
    users.groups.${userName} = { };
    users.users."${nginxCfg.user}" = lib.mkIf cfg.enableNginx {
      extraGroups = [ userName ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.reportDir}/ 750 ${userName} ${userName}"
      "Z ${cfg.reportDir} 750 ${userName} ${userName}"
    ];

    systemd.services."${serviceName}" = {
      enable = true;
      description = "${serviceName} real-time dashboard service";
      restartIfChanged = true;
      restartTriggers = [ pkgs.goaccess ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
        User = userName;
        Group = userName;
        WorkingDirectory = cfg.dataDir;
        Type = "simple";

        ExecStart =
          let
            keys = builtins.attrNames cfg.extraFlags;
            fragments = map
              (k:
                let v = cfg.extraFlags.${k}; in
                "--${k}='${v}'"
              )
              keys;
            flagsString = builtins.concatStringsSep " " fragments;

            geoipFragments = map (v: "--geoip-database=${v}") cfg.geoipDbPaths;
            geoipFlags = builtins.concatStringsSep " " geoipFragments;

            script = ''
              ${cfg.package}/bin/goaccess --log-file=${cfg.logFilePath} \
                --log-format='${if cfg.logFileFormat != null then cfg.logFileFormat else cfg.logFormatCustom}' \
                --anonymize-ip --persist --restore --db-path=${cfg.dataDir} \
                --keep-last=${toString cfg.dataRetentionDays} \
                --all-static-files --real-time-html \
                ${if cfg.reportTitle != null then "--html-report-title\"${cfg.reportTitle}\"" else ""} \
                --output=${cfg.reportDir}/index.html --addr=127.0.0.1 \
                --port=${toString cfg.port} \
                --ws-url=wss://${cfg.serverHost}:443/${cfg.serverPath}ws \
                --origin=https://${cfg.serverHost} \
                ${geoipFlags} \
                ${flagsString}
            '';
          in
          "${pkgs.writeShellScript "goaccess-run" script}";

        AmbientCapabilities = [ ];
        CapabilityBoundingSet = [
          "~CAP_RAWIO"
          "~CAP_MKNOD"
          "~CAP_AUDIT_CONTROL"
          "~CAP_AUDIT_READ"
          "~CAP_AUDIT_WRITE"
          "~CAP_SYS_BOOT"
          "~CAP_SYS_TIME"
          "~CAP_SYS_MODULE"
          "~CAP_SYS_PACCT"
          "~CAP_LEASE"
          "~CAP_LINUX_IMMUTABLE"
          "~CAP_IPC_LOCK"
          "~CAP_BLOCK_SUSPEND"
          "~CAP_WAKE_ALARM"
          "~CAP_SYS_TTY_CONFIG"
          "~CAP_MAC_ADMIN"
          "~CAP_MAC_OVERRIDE"
          "~CAP_NET_ADMIN"
          "~CAP_NET_BROADCAST"
          "~CAP_NET_RAW"
          "~CAP_SYS_ADMIN"
          "~CAP_SYS_PTRACE"
          "~CAP_SYSLOG"
        ];
        DevicePolicy = "closed";
        KeyringMode = "private";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
    };

    services.nginx = lib.mkIf cfg.enableNginx {
      enable = true;
      virtualHosts."${cfg.serverHost}" = {
        forceSSL = cfg.nginxEnableSSL;
        basicAuthFile = cfg.nginxBasicAuthFile;
        locations = {
          "/${cfg.serverPath}" = {
            alias = "${cfg.reportDir}/";
            extraConfig = ''
              add_header Cache-Control 'private no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
              if_modified_since off;
              expires off;
              etag off;
            '';
          };
          "/${cfg.serverPath}ws" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            proxyWebsockets = true;
          };
        };
      }
      // lib.optionalAttrs (cfg.nginxEnableSSL && cfg.nginxACMEHost == null) { enableACME = cfg.nginxEnableSSL; }
      // lib.optionalAttrs (cfg.nginxEnableSSL && cfg.nginxACMEHost != null) { useACMEHost = cfg.nginxACMEHost; };
    };
  };
}
