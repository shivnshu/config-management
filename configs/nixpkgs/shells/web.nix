let
  pkgs = import <nixpkgs> {};
in
  { stdenv ? pkgs.stdenv }:

  stdenv.mkDerivation {
    name = "pythonReq";
    buildInputs = [
      pkgs.python3
      pkgs.python36Packages.ipython
      pkgs.python36Packages.requests
      pkgs.python36Packages.beautifulsoup4
      pkgs.python36Packages.xmltodict
    ];
}
