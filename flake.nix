{
  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, flake-compat, flake-utils, nixpkgs, }:
    flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ] (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        defaultPackage = packages.site;
        devShell = pkgs.mkShell {
          packages = [ pkgs.ghp-import pkgs.lychee ];
          inputsFrom = [ defaultPackage ];
        };
        packages.site = pkgs.stdenvNoCC.mkDerivation {
          name = "umn-plseminar.github.io";
          src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;
          nativeBuildInputs = [ pkgs.hugo ];
          buildPhase = "hugo -d $out -F";
          installPhase = "true";
        };
      });
}
