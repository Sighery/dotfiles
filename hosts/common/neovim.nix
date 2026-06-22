{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = lib.mkDefault true;
    withPython3 = lib.mkDefault true;
    withNodeJs = lib.mkDefault true;
    vimAlias = lib.mkDefault true;
    defaultEditor = lib.mkDefault true;

    configure = lib.mkDefault {
      customRC = ''
        set number relativenumber
        set tabstop=4 shiftwidth=4
        syntax on
        set ruler
        set smarttab
      '';
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [ guess-indent-nvim ];
        opt = [ ];
      };
    };
  };
}
