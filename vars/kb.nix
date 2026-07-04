rec {
  br = {
    inherit (default) options;
    layout = "br";
    variant = "nodeadkeys";
  };
  us = {
    inherit (default) options;
    layout = "us";
    variant = "altgr-intl";
  };
  default = {
    layout = builtins.concatStringsSep "," [br.layout us.layout];
    variant = builtins.concatStringsSep "," [br.variant us.variant];
    options = "grp:alt_space_toggle";
  };
}
