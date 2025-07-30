{
  description = "basic handdara FORTRAN env flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nativeBuildInputs = with pkgs; [
        fortls
        alejandra
        just
        universal-ctags
      ];
      buildInputs = with pkgs; [
        gfortran
      ];
    in {
      devShells.default = pkgs.mkShell {
        inherit nativeBuildInputs buildInputs;
      };
    });
}
