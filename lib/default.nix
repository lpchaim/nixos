{inputs, ...} @ topArgs: let
  args = topArgs // {inherit (inputs.nixpkgs) lib;};
in {
  shared = import ./shared.nix args;
  shell = import ./shell.nix;
  storage = import ./storage.nix;
  strings = import ./strings.nix args;
}
