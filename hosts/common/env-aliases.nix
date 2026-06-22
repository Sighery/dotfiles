{ ... }:

{
  environment.shellAliases = {
    ls = "eza -F";
    exa = "eza -F";
    grep = "grep --colour=auto";
    egrep = "egrep --colour=auto";
    fgrep = "fgrep --colour=auto";
    cp = "cp -i";
    less = "less -x4 -R";
    more = "less -x4 -R";
    ll = "eza --long --git --header --links --group --classify";
    exal = "eza --long --git --header --links --group --classify";
    la = "eza --all --classify";
    exaa = "eza --all --classify";
    exala = "eza --all --long --git --header --links --group --classify";
    kitten = "kitty +kitten";
    diff = "colordiff -u";
    colordiff = "colordiff -u";
  };
}
