{inputs, ...} @ args: (
  final: prev:
    import "${inputs.self}/nix/packages" args
)
