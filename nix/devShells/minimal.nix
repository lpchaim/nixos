{
  perSystem = {pkgs, ...}: {
    make-shells.minimal = {
      additionalArguments.meta.description = "Minimal shell with cli essentials";

      env.EDITOR = "hx";
      packages = with pkgs; [
        bat
        fish
        git
        helix
      ];
    };
  };
}
