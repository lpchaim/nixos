{
  shared = {
    nix.settings = {
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://nyx.chaotic.cx"
        "https://snowflakeos.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
        "snowflakeos.cachix.org-1:gXb32BL86r9bw1kBiw9AJuIkqN49xBvPd1ZW8YlqO70="
      ];
      keep-derivations = true;
      keep-outputs = true;
    };
    kb = rec {
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
      default =
        let
          mkMerge = builtins.concatStringsSep ",";
        in
        {
          layout = mkMerge [ br.layout us.layout ];
          variant = mkMerge [ br.variant us.variant ];
          options = "compose:ralt,grp:alt_space_toggle";
        };
    };
  };
}
