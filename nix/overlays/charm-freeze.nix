_: final: prev: {
  charm-freeze = prev.charm-freeze.overrideAttrs (oldAttrs: {
    patches = [
      (prev.fetchpatch {
        name = "0001-read-user-fonts.patch";
        url = "https://github.com/charmbracelet/freeze/commit/f37de5e85f4eaa041f997897ea5d6b98e1373ed8.patch";
        hash = "sha256-u7SgPTopb3RbhuFQdPOqqmJVsxbyGEhPV0AqCBtNHq0=";
      })
    ];
    nativeBuildInputs =
      (oldAttrs.nativeBuildInputs or [])
      ++ [prev.makeWrapper];
    postFixup = ''
      ${oldAttrs.postFixup or ""}
      wrapProgram $out/bin/freeze --add-flags "--config user"
    '';
  });
}
