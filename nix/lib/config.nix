{
  inputs,
  lib,
  ...
}: let
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
  ssh.publicKeys = {
    github = ../../keys/github.pub;
    tangled = ../../keys/tangled.pub;
    perHost =
      ../../secrets/perHost
      |> lib.filesystem.listFilesRecursive
      |> builtins.filter (lib.hasSuffix "ssh.pub")
      |> map (value: {
        inherit value;
        name =
          value
          |> toString
          |> lib.splitString "/"
          |> lib.reverseList
          |> (list: lib.elemAt list 1);
      })
      |> builtins.listToAttrs;
    perYubikey = {
      "25388788" = ../../keys/yubikey-25388788.pub;
      "26583315" = ../../keys/yubikey-26583315.pub;
    };
  };
  nix = {
    pkgs = {
      config = {
        allowUnfree = true;
      };
      overlays = builtins.attrValues inputs.self.overlays;
    };
    settings = {
      accept-flake-config = true;
      builders-use-substitutes = true;
      auto-optimise-store = true;
      extra-experimental-features = "flakes nix-command pipe-operator";
      extra-substituters = [
        # cache.nixos.org is set by default
        "https://lpchaim.cachix.org"
        "https://nix-comunity.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      extra-trusted-public-keys = [
        "lpchaim.cachix.org-1:2xOuvojcUDNhJRzCpvgewQ2DdNZz3QzGVV4Z/7C+Lio="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      http-connections = 100;
      keep-derivations = true;
      keep-outputs = true;
      max-jobs = "auto";
      max-substitution-jobs = 100;
      trusted-users = ["root" "@wheel"];
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
