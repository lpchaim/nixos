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
    http-connections = 100;
    keep-derivations = true;
    keep-outputs = true;
    max-jobs = "auto";
    max-substitution-jobs = 100;
    substituters = [
      "https://cache.nixos.org?priority=1"
      "https://nix-community.cachix.org?priority=2"
      "https://lpchaim.cachix.org?priority=3"
      "https://nix-gaming.cachix.org?priority=4"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lpchaim.cachix.org-1:2xOuvojcUDNhJRzCpvgewQ2DdNZz3QzGVV4Z/7C+Lio="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
    trusted-users = ["root" "@wheel"];
  };
}
