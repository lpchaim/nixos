{
  perSystem = {pkgs, ...}: {
    make-shells.nix = {
      additionalArguments.meta.description = "Nix development environment";
      packages = with pkgs; [
        age
        alejandra
        nil
        nixpkgs-fmt
        sops
        ssh-to-age
      ];
    };
  };
}
