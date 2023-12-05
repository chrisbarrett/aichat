{
  inputs.naersk.url = "github:nix-community/naersk";

  outputs = { nixpkgs, flake-utils, naersk, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
        stdenv = pkgs.stdenv;
        naersk' = pkgs.callPackage naersk { };

        nativeBuildInputs = with pkgs; [
          libiconv
        ] ++
        lib.optional stdenv.isDarwin (
          with pkgs.darwin.apple_sdk.frameworks; [
            AppKit
          ]
        );
      in
      {
        name = "aichat";

        defaultPackage = naersk'.buildPackage {
          inherit nativeBuildInputs;
          src = ./.;
        };

        devShell = pkgs.mkShell {
          inherit nativeBuildInputs;
          buildInputs = [ pkgs.rustup ];
        };
      });
}
