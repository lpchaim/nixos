_: final: prev: {
  termshot = prev.termshot.overrideAttrs (oldAttrs: {
    patches = [
      (prev.fetchpatch {
        name = "0001-add-fonts-coloschemes.patch";
        url = "https://github.com/homeport/termshot/commit/8d62a321e2ece245cd318f6c74b50a97911ee7a0.patch";
        hash = "sha256-IPzORyLXkGK6HvP9w11sv/Tbtwju1QFitXeLfTJYWeU=";
      })
    ];
    vendorHash = "sha256-d6SXgI+khSD/uj1XY/xCYjklU1S1Hw2mRn12a3+a7Xg=";
  });
}
