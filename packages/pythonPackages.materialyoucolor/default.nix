{
  lib,
  fetchPypi,
  python3Packages,
  ...
}:
python3Packages.buildPythonPackage rec {
  pname = "materialyoucolor";
  version = "2.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J35//h3tWn20f5ej6OXaw4NKnxung9q7m0E4Zf9PUw4=";
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/T-Dynamos/materialyoucolor-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [lpchaim];
  };
}
