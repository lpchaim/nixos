{inputs, ...}: final: prev: {
  python = final: prev: {
    pythonPackagesExtensions =
      prev.pythonPackagesExtensions
      ++ [
        (pyfinal: pyprev: {
          mss = pyprev.mss.overridePythonAttrs (oldAttrs: {
            doCheck = false;
            prePatch = ''
              rm -rf src/tests/*
            '';
          });
        })
      ];
  };
}
