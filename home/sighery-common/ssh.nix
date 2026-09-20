{ osConfig, secrets, ... }:

let
  hostname = osConfig.networking.hostName;
in
{
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;

    #addKeysToAgent = "yes";
    enableDefaultConfig = false;

    #extraConfig = ''
    #Match host kcolor exec "${pkgs.iputils}/bin/ping -c1 -W1 192.168.0.116 >/dev/null 2>&1"
    #  HostName 192.168.0.116
    #
    #   Match host kcolor exec "${pkgs.iputils}/bin/ping -c1 -W1 192.168.0.117 >/dev/null 2>&1"
    #    HostName 192.168.0.117
    # '';

    settings = {
      "github.com" = {
        user = secrets.git.github.personal_email;
        identityFile = "~/.ssh/${hostname}_github";
        identitiesOnly = true;
      };
      "gitlab.com" = {
        user = "4689618-Sighery@users.noreply.gitlab.com";
        identityFile = "~/.ssh/id_gitlab";
        identitiesOnly = true;
      };
      "codeberg.org" = {
        user = secrets.git.codeberg.personal_email;
        identityFile = "~/.ssh/${hostname}_codeberg";
        identitiesOnly = true;
      };

      "panda" = {
        user = "panda";
        hostname = "192.168.0.193";
        identityFile = "~/.ssh/panda_panda-${hostname}";
        identitiesOnly = true;
      };
      "wilem" = {
        user = "wilem";
        hostname = "sighery.com";
        port = builtins.elemAt secrets.wilem.ssh.ports 0;
        identityFile = "~/.ssh/wilem_wilem-${hostname}";
        identitiesOnly = true;
      };
      "tiber" = {
        user = "sighery";
        hostname = secrets.home_lan.tiber_wlp;
        identityFile = "~/.ssh/tiber_sighery-${hostname}";
        identitiesOnly = true;
      };
      "loxez" = {
        user = "sighery";
        hostname = secrets.home_lan.loxez_eth;
        identityFile = "~/.ssh/loxez_sighery-${hostname}";
        identitiesOnly = true;
      };

      "kpw5" = {
        user = "root";
        #hostname = "192.168.0.43";
        hostname = "kpw5";
        identityFile = "~/.ssh/kpw5";
        identitiesOnly = true;
        WarnWeakCrypto = "no";
      };
      "kpw5-usb" = {
        user = "root";
        hostname = "192.168.15.244";
        identityFile = "~/.ssh/kpw5";
        identitiesOnly = true;
        WarnWeakCrypto = "no";
      };
      # "kcolor-116" = lib.hm.dag.entryAfter [ "*" ] {
      #   #match = ''originalhost kcolor exec "${pkgs.netcat}/bin/nc -z -w1 192.168.0.116 22 >/dev/null 2>&1"'';
      #   match = ''originalhost kcolor exec "${pkgs.netcat}/bin/nc -z -w1 192.168.0.116 22 >/dev/null 2>&1"'';
      #   hostname = "192.168.0.116";
      # };
      # "kcolor-117" = lib.hm.dag.entryAfter [ "*" ] {
      #   #match = ''originalhost kcolor exec "${pkgs.netcat}/bin/nc -z -w1 192.168.0.117 22 >/dev/null 2>&1"'';
      #   match = ''originalhost kcolor exec "${pkgs.netcat}/bin/nc -z -w1 192.168.0.117 22 >/dev/null 2>&1"'';
      #   hostname = "192.168.0.117";
      # };
      # "kcolor-usb" = lib.hm.dag.entryAfter [ "*" ] {
      #   #match = ''originalhost kcolor exec "${pkgs.netcat}/bin/nc -z -w1 192.168.0.117 22 >/dev/null 2>&1"'';
      #   match = ''originalhost kcolor exec "${pkgs.netcat}/bin/nc -z -w1 192.168.15.244 22 >/dev/null 2>&1"'';
      #   hostname = "192.168.15.244";
      # };
      #"kcolor-real" = {
      #  match = ''originalhost kcolor'';
      #  host = "kcolor-real";
      #};
      #"kcolor" = { # Fallback
      #  hostname = "192.168.15.244";
      #};
      "kcolor" = {
        user = "root";
        hostname = "kcolor";
        identityFile = "~/.ssh/kcolor";
        identitiesOnly = true;
        WarnWeakCrypto = "no";
      };
      "kcolor-usb" = {
        user = "root";
        hostname = "192.168.15.244";
        identityFile = "~/.ssh/kcolor";
        identitiesOnly = true;
        WarnWeakCrypto = "no";
      };
      # "kcolor" = {
      #   user = "root";
      #   identityFile = "~/.ssh/kcolor";
      #   identitiesOnly = true;
      #   #hostname = "192.168.15.244";
      #   extraOptions = {
      #     WarnWeakCrypto = "no";
      #   };
      # };
      #"kcolor" = {
      #  user = "root";
      #hostname = "192.168.0.116";
      #  hostname = "kcolor";
      #  identityFile = "~/.ssh/kcolor";
      #  identitiesOnly = true;
      #extraOptions = {
      #  CanonicalizeHostname = "no";
      #  CanonicalDomains = "none";
      #};
      #};
      "kscribe" = {
        user = "root";
        #hostname = "192.168.0.112";
        hostname = "kscribe";
        identityFile = "~/.ssh/kscribe";
        identitiesOnly = true;
        WarnWeakCrypto = "no";
      };
      "kscribe-usb" = {
        user = "root";
        hostname = "192.168.15.244";
        identityFile = "~/.ssh/kscribe";
        identitiesOnly = true;
        WarnWeakCrypto = "no";
      };

      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "yes";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
}
