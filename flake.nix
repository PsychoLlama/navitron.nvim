{
  description = "Test environment";

  inputs.dotfiles.url = "github:PsychoLlama/dotfiles";

  outputs = { self, nixpkgs, dotfiles }:
    let
      inherit (nixpkgs) lib;
      systems = [ "x86_64-linux" ];

      pkgsFor = system:
        import nixpkgs {
          inherit system;
          overlays = [ dotfiles.overlays.vim-plugins ];
        };

      eachSystem = f:
        lib.pipe systems [
          (map (system: lib.nameValuePair system (pkgsFor system)))
          lib.listToAttrs
          (lib.mapAttrs f)
        ];

    in {
      # Builds a variant of my editor using the local navitron plugin.
      devShell = eachSystem (system: pkgs:
        pkgs.mkShell {
          buildInputs = [
            (dotfiles.lib.buildEditor {
              inherit system;

              config = {
                presets.base.enable = true;
                plugins.navitron-nvim.enable = false;

                extraConfig = lib.mkBefore ''
                  " Add the repo root as a plugin.
                  exe 'set rtp^=' . systemlist('git rev-parse --show-toplevel')[0]
                '';
              };
            })
          ];
        });
    };
}
