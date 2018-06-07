let
    pkgs = import <nixpkgs> {};
in
    { stdenv ? pkgs.stdenv }:

    stdenv.mkDerivation {
        name = "network";
        buildInputs = [
            pkgs.ettercap
        ];
    }
