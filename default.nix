with import <nixpkgs> {};

(python36.withPackages (ps: [python36Packages.pyaml])).env
