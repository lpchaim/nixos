{
  perSystem = {pkgs, ...}: {
    make-shells.nix = {
      additionalArguments.meta.description = "Nix development environment";
      packages = with pkgs; [
        age
        alejandra
        nil
        nixd
        nixpkgs-fmt
        sops
        ssh-to-age
      ];
    };
  };
}
