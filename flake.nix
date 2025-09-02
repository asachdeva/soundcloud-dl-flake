{
  description = "A Nix flake for yt-dlp, a CLI tool to download SoundCloud and other media";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        yt-dlp = pkgs.python3Packages.buildPythonApplication {
          pname = "yt-dlp";
          version = "2025.08.27";
          pyproject = true; # Specific version for reproducibility
          src = pkgs.fetchFromGitHub {
            owner = "yt-dlp";
            repo = "yt-dlp";
            rev = "2025.08.27"; # Use specific tag or commit
            sha256 = "sha256-E8++/gK/SpY93UW/9U266Qj1Kkn6CeNou7bKTqpCgFw="; #Placeholder, update after running
          };
          nativeBuildInputs = with pkgs.python3Packages; [ hatchling ];
          propagatedBuildInputs = with pkgs.python3Packages; [
            mutagen
            pycryptodomex
            requests
            urllib3
            websockets
            certifi
            brotli
          ];
          buildInputs = [ pkgs.ffmpeg ]; # For audio processing and thumbnail embedding
          doCheck = false; # Skip tests to avoid network dependencies
        };
      in
      {
        packages.default = yt-dlp;
        devShells.default = pkgs.mkShell {
          buildInputs = [ yt-dlp pkgs.python3 pkgs.ffmpeg ];
        };
      }
    );
}
