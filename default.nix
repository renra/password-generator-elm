{ nixpkgs ? import <nixpkgs> {  } }:

let
  pkgs = [
    nixpkgs.nodejs
    nixpkgs.gzip
    nixpkgs.coreutils
    nixpkgs.libsass
  ];

in
  nixpkgs.stdenv.mkDerivation {
    name = "password-generator";
    buildInputs = pkgs;
  }
