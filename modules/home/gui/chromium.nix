{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.home-manager.lib) hm;
in {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--disable-gpu-compositing" # @TODO Remove after NVIDIA figures this out
    ];
    package = pkgs.brave;
  };
}
