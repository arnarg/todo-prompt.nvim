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
        buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
        currDir = builtins.getEnv "PWD";
      in rec {
        packages.todo-prompt-nvim = buildVimPlugin {
          pname = "todo-prompt-nvim";
          version = "0.1";
          src = ./.;
          nativeBuildInputs = with pkgs; [ go ];
          preConfigure = ''
            export GOCACHE=$TMPDIR/go-cache
            export GOPATH="$TMPDIR/go"
            export GOSUMDB=off
          '';
        };
        defaultPackage = packages.todo-prompt-nvim;

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            go
            gnumake
            gcc
            luajit
            luajitPackages.busted
            luajitPackages.luacov
          ];
          LUA_PATH = "${currDir}/lua/?.lua;${currDir}/lua/?/init.lua";
        };
      }
    );
}
