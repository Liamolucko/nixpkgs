{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
  wheel,
}:
let
  mkPythondata =
    {
      kind,
      name,
      hash,
      license,
      doCheck ? true,
    }:
    let
      dashedName = builtins.replaceStrings [ "_" ] [ "-" ] name;
    in
    buildPythonPackage rec {
      pname = "pythondata-${kind}-${dashedName}";
      version = "2025.04";
      pyproject = true;

      src = fetchFromGitHub {
        owner = "litex-hub";
        repo = "pythondata-${kind}-${name}";
        tag = version;
        inherit hash;
        fetchSubmodules = true;
      };

      build-system = [
        setuptools
        wheel
      ];

      inherit doCheck;
      checkPhase = ''
        runHook preCheck

        pushd "$out"
        ${python.interpreter} "$OLDPWD/test.py"
        popd

        runHook postCheck
      '';

      meta = {
        description = "Python module containing data files for ${name} ${kind} (for use with LiteX)";
        homepage = "https://github.com/litex-hub/pythondata-${kind}-${name}";
        inherit license;
        maintainers = with lib.maintainers; [ Liamolucko ];
      };
    };
in
{
  pythondata-software-picolibc = mkPythondata {
    kind = "software";
    name = "picolibc";
    hash = "sha256-0OpEdBGu/tkFFPUi1RLsTqF2tKwLSfYIi+vPqgfLMd8=";
    license = lib.licenses.bsd3;
  };
}
