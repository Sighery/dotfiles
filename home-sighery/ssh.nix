{ osConfig, inputs, ... }:

let
  hostname = osConfig.networking.hostName;
in
{
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
        user = inputs.dotfiles-secrets.git.github.personal_email;
        identityFile = "~/.ssh/${hostname}_github";
        identitiesOnly = true;
      };
      "gitlab.com" = {
        user = "4689618-Sighery@users.noreply.gitlab.com";
        identityFile = "~/.ssh/id_gitlab";
        identitiesOnly = true;
      };
      "saterpi3" = {
        user = "sighery";
        hostname = "192.168.0.30";
        identityFile = "~/.ssh/id_saterpi";
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
      "wilem" = {
        user = "wilem";
        hostname = "sighery.com";
        port = builtins.elemAt inputs.dotfiles-secrets.wilem.ssh.ports 0;
        identityFile = "~/.ssh/wilem_wilem-${hostname}";
        identitiesOnly = true;
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

  services.ssh-agent.enable = true;
}
