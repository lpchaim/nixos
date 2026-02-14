{lib, ...}: let
  assets = ../../assets;
  filter = prefix: (name: type: type == "regular" && lib.strings.hasPrefix prefix name);
  assetWithPrefix = prefix:
    (builtins.readDir assets)
    |> lib.filterAttrs (filter prefix)
    |> builtins.attrNames
    |> builtins.head
    |> (x: assets + /${x});
in {
  name.user = "lpchaim";
  name.full = "Luna Perroni";
  email.main = "lpchaim@proton.me";
  flake.path = "~/.config/nixos";
  repo.main = "https://github.com/lpchaim/nixos";
  shell = "fish";
  wallpaper = assetWithPrefix "wallpaper";
  profilePicture = assetWithPrefix "profile-picture";
  nix = {
    pkgs.config = {
      allowUnfree = true;
    };
    settings = {
      accept-flake-config = true;
      builders-use-substitutes = true;
      auto-optimise-store = true;
      extra-experimental-features = "flakes nix-command pipe-operator";
      extra-substituters = [
        # The NixOS and nix-community ones are set by default
        "https://lpchaim.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "lpchaim.cachix.org-1:2xOuvojcUDNhJRzCpvgewQ2DdNZz3QzGVV4Z/7C+Lio="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      keep-derivations = true;
      keep-outputs = true;
      max-jobs = "auto";
    };
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
    default = let
      mkMerge = builtins.concatStringsSep ",";
    in {
      layout = mkMerge [br.layout us.layout];
      variant = mkMerge [br.variant us.variant];
      options = "grp:alt_space_toggle";
    };
  };
}
