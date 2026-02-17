{
  perSystem = {pkgs, ...}: {
    make-shells.nix = {
      additionalArguments.meta.description = "Nix development environment";
      additionalArguments.passthru.my.ci.buildFor = ["x86_64-linux"];

      packages = with pkgs; [
        alejandra
        nil
        nixd
        nixpkgs-fmt
      ];
    };
  };
}
