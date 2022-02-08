{
  description = "A work-in-progress neovim plugin for adding todo with a prompt";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        currDir = builtins.getEnv "PWD";
      in rec {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            luajit
            luajitPackages.busted
          ];
          LUA_PATH = "${currDir}/lua/?.lua;${currDir}/lua/?/init.lua";
        };
      }
    );
}
