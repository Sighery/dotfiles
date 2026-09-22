{ ... }:

let
  ncro-port = "8089";
in
{
  services.ncro = {
    enable = true;

    settings = {
      server.listen = ":${ncro-port}";
      logging.timestamps = false;

      upstreams = [
        {
          url = "https://cache.nixos.org";
          priority = 10;
          public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        }
        # Ncro cache because it takes ages to build
        # https://github.com/manic-systems/ncro/issues/29
        # https://github.com/NixOS/nixpkgs/pull/533027
        {
          url = "https://ci.manic.systems/projects/ncro/nix-cache";
          priority = 60;
          public_key = "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s=";
        }
      ];
    };
  };

  nix.settings.substituters = [ "http://localhost:${ncro-port}" ];
}
