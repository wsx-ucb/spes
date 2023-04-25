{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [(final: prev: {
            z3 = prev.z3.override { javaBindings = true; };
          })];
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ openjdk maven z3 ];
          LD_LIBRARY_PATH = pkgs.lib.strings.makeLibraryPath (with pkgs; [ z3 ]);
        };
      }
    );
}
