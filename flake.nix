{
  description = "Flake that installs JetBrainsMono Nerd Font";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        jetbrainsMonoNerd = pkgs.stdenv.mkDerivation {
          pname = "jetbrains-mono-nerd-font";
          version = "3.4.0";
          dontUnpack = true;
          
          src = pkgs.fetchzip {
            url = "https://github.com/CoryMConway/jetbrains-mono-flake/releases/download/0.0.1/JetBrainsMono.zip";
            sha256 = "76f05ff3ace48a464a6ca57977998784ff7bdbb65a6d915d7e401cd3927c493c";
          };

          nativeBuildInputs = [ pkgs.unzip ];

          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            unzip -j $src -d $out/share/fonts/truetype
          '';
        };
      in
      {
        packages.default = jetbrainsMonoNerd;

        nixosModules.font = {
          config,
          lib,
          pkgs,
          ...
        }: {
          fonts.packages = [ self.packages.${system}.default ];
        };
      }
    );
}
