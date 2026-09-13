{inputs, ...}: {
  pkgs = {
    config.allowUnfree = true;
    overlays = builtins.attrValues inputs.self.overlays;
  };
  settings = {
    accept-flake-config = true;
    auto-optimise-store = true;
    builders-use-substitutes = true;
    extra-experimental-features = "flakes nix-command pipe-operator";
    http-connections = 20;
    keep-derivations = true;
    keep-outputs = true;
    max-jobs = "auto";
    max-substitution-jobs = 20;
    substituters = [
      "https://cache.nixos.org?priority=1"
      "https://nix-community.cachix.org?priority=2"
      "https://cache.nixos-cuda.org?priority=3"
      "https://lpchaim.cachix.org?priority=4"
      "https://nix-gaming.cachix.org?priority=5"
      "https://freesmlauncher.cachix.org?priority=6"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "freesmlauncher.cachix.org-1:hX0BqSt13djXVbhagJ6toEEBA15xxZPWwKGpYksuiQ0="
      "lpchaim.cachix.org-1:2xOuvojcUDNhJRzCpvgewQ2DdNZz3QzGVV4Z/7C+Lio="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
    trusted-users = ["root" "@wheel"];
  };
}
