{libfprint, ...}:
libfprint.overrideAttrs (oldAttrs: {
  patches =
    (oldAttrs.patches or [])
    ++ [./001-add-canvasbio.patch];
})
