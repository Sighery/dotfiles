{ config, lib, pkgs, ... }:

let
  serviceName = "srtla-relay";
  cfg = config.services."${serviceName}";
  dataDirectory = "/var/lib/${serviceName}";
  userName = cfg.userName;
  types = lib.types;

  slsBinary =
    if cfg.stack == "OpenIRL" then "${pkgs.openirl-srt-live-server}/bin/sls"
    else "${pkgs.irlserver-irl-srt-server}/bin/srt_server";
  srtlaRecBinary =
    if cfg.stack == "OpenIRL" then "${pkgs.openirl-srtla}/bin/srtla_rec"
    else "${pkgs.openirl-srtla}/bin/srtla_rec";
in
{
  options.services."${serviceName}" = {
    enable = lib.mkEnableOption "${serviceName} service";

    userName = lib.mkOption {
      type = types.nonEmptyStr;
      default = "srtla-relay";
      description = "Default user for SLS.";
    };

    slsConfig = lib.mkOption {
      type = types.nonEmptyStr;
      description = ''
        SLS configuration.
        For reference, check <https://github.com/irlserver/irl-srt-server/blob/16a66c531f7a71ef05e47ccfb707f0e1862b30e1/src/sls.conf>.
      '';
    };

    stack = lib.mkOption {
      type = types.enum [ "OpenIRL" "IRLServer" ];
      default = "OpenIRL";
      description = "Custom SRTLA Relay stack to use.";
    };

    # slsBinary = lib.mkOption {
    #   type = types.path;
    #   description = ''
    #     Binary to run the sls config.
    #     For IRLServer stack: ${pkgs.irlserver-irl-srt-server}/bin/srt_server
    #     For OpenIRL stack: ${pkgs.openirl-srt-live-server}/bin/sls
    #   '';
    # };

    srtlaRec = {
      srtlaPort = lib.mkOption {
        type = types.port;
        default = 5000;
        description = ''
          srtla_rec SRTLA port.
        '';
      };

      srtHostname = lib.mkOption {
        type = types.nonEmptyStr;
        default = "localhost";
        description = ''
          srtla_rec hostname.
        '';
      };

      srtPort = lib.mkOption {
        type = types.port;
        default = 4002;
        description = ''
          srtla_rec SRT port. Should match slsConfig's srt.server.listen_publisher_srtla.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # environment.systemPackages =
    #   lib.optional (cfg.stack == "OpenIRL") [
    #     pkgs.openirl-srt
    #     pkgs.openirl-srtla
    #     pkgs.openirl-srt-live-server
    #   ] ++ lib.optional (cfg.stack == "IRLServer") [
    #     pkgs.irlserver-srt
    #     pkgs.irlserver-srtla
    #     pkgs.irlserver-irl-srt-server
    #   ];

    users.users.${userName} = {
      isSystemUser = true;
      group = userName;
      home = dataDirectory;
      createHome = true;
    };
    users.groups.${userName} = { };

    systemd.services."${serviceName}" = {
      enable = true;
      description = "SRT/LA Relay";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = userName;
        Group = userName;
        # WorkingDirectory = dataDirectory;
        StateDirectory = baseNameOf dataDirectory;
        # Type = "simple";
        # DynamicUser = true;
        # StateDirectory = baseNameOf dataDirectory;

        Restart = "on-failure";
        ExecStartPre =
          let
            slsConfig = pkgs.writeTextFile {
              name = "sls-config";
              text = cfg.slsConfig;
            };
          in
          "${pkgs.writers.writeBash "${serviceName}-copy-settings" ''
            install -dm740 ${dataDirectory}
            install -Dm400 ${slsConfig} ${dataDirectory}/sls.conf
          ''}";

        ExecStart = "${slsBinary} -c ${dataDirectory}/sls.conf";
      };
    };

    systemd.services."srtla-receiver" = {
      description = "SRTLA Receiver";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "srtla-relay.service" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "srtla-receiver";

        Restart = "on-failure";
        ExecStart = "${srtlaRecBinary} --srtla_port=${toString cfg.srtlaRec.srtlaPort} --srt_hostname=${cfg.srtlaRec.srtHostname} --srt_port=${toString cfg.srtlaRec.srtPort}";
      };
    };
  };
}
