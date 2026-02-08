{
  perSystem = {pkgs, ...}: {
    make-shells.nix = {
      additionalArguments.meta.description = "Nix development environment";
      packages = with pkgs; [
        age
        alejandra
        nixd
        nixpkgs-fmt
        sops
        ssh-to-age
      ];
    };
  };
}
