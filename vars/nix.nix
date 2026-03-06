{inputs, ...}: {
  pkgs = {
    config.allowUnfree = true;
    overlays = builtins.attrValues inputs.self.overlays;
  };
  settings = {
    accept-flake-config = true;
    builders-use-substitutes = true;
    auto-optimise-store = true;
    extra-experimental-features = "flakes nix-command pipe-operator";
    extra-substituters = [
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
}
