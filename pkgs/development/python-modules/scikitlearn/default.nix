{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, gfortran, glibcLocales
, numpy, scipy, pytest, pillow
, cython
, joblib
, llvmPackages
, threadpoolctl
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.24.1";
  # UnboundLocalError: local variable 'message' referenced before assignment
  disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchPypi {
    inherit pname version;
    sha256 = "oDNKGALmTWVgIsO/q1anP71r9LEpg0PzaIryFRgQu98=";
  };

  buildInputs = [
    pillow
    gfortran
    glibcLocales
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    numpy.blas
    joblib
    threadpoolctl
  ];
  checkInputs = [ pytest ];

  LC_ALL="en_US.UTF-8";

  doCheck = !stdenv.isAarch64;
  # Skip test_feature_importance_regression - does web fetch
  checkPhase = ''
    cd $TMPDIR
    HOME=$TMPDIR OMP_NUM_THREADS=1 pytest -k "not test_feature_importance_regression" --pyargs sklearn
  '';

  meta = with lib; {
    description = "A set of python modules for machine learning and data mining";
    changelog = let
      major = versions.major version;
      minor = versions.minor version;
      dashVer = replaceChars ["."] ["-"] version;
    in
      "https://scikit-learn.org/stable/whats_new/v${major}.${minor}.html#version-${dashVer}";
    homepage = "https://scikit-learn.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
