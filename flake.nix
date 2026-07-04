{
  description = "Development environment";

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
    }:

    let
      inherit (nixpkgs) lib;

      eachSystem = lib.flip lib.mapAttrs (
        lib.genAttrs (import systems) (system: import nixpkgs { inherit system; })
      );
    in

    {
      packages = eachSystem (
        system: pkgs: rec {
          default = navitron-nvim;

          navitron-nvim = pkgs.vimUtils.buildVimPlugin {
            pname = "navitron.nvim";
            version = self.shortRev or "latest";
            src = lib.fileset.toSource {
              root = ./.;
              fileset = lib.fileset.difference ./. (
                lib.fileset.fileFilter (file: lib.hasSuffix "_spec.lua" file.name) ./.
              );
            };
          };
        }
      );

      devShells = eachSystem (
        system: pkgs: rec {
          # For developing locally. Uses the system neovim.
          default = pkgs.mkShell {
            packages = [
              pkgs.just
              pkgs.lua-language-server
              pkgs.luajitPackages.luacheck
              pkgs.luajitPackages.vusted
              pkgs.nixfmt
              pkgs.stylua
              pkgs.treefmt
            ];
          };

          # For CI. Uses an unconfigured neovim package.
          ci = pkgs.mkShell {
            inputsFrom = [ default ];
            packages = [ pkgs.neovim ];
          };
        }
      );
    };
}
