{
  description = "Flake that installs JetBrainsMono Nerd Font";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      # Create system-specific packages
      systemOutputs = flake-utils.lib.eachDefaultSystem (system:
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
        }
      );
    in
    systemOutputs // {
      # Add system-agnostic nixosModules
      nixosModules.default = { config, lib, pkgs, ... }: {
        fonts.packages = [ self.packages.${pkgs.system}.default ];
      };
      
      # For backwards compatibility, also provide system-specific modules
      nixosModules.x86_64-linux = { config, lib, pkgs, ... }: {
        fonts.packages = [ self.packages.x86_64-linux.default ];
      };
      nixosModules.aarch64-linux = { config, lib, pkgs, ... }: {
        fonts.packages = [ self.packages.aarch64-linux.default ];
      };
      nixosModules.x86_64-darwin = { config, lib, pkgs, ... }: {
        fonts.packages = [ self.packages.x86_64-darwin.default ];
      };
      nixosModules.aarch64-darwin = { config, lib, pkgs, ... }: {
        fonts.packages = [ self.packages.aarch64-darwin.default ];
      };
    };
}
