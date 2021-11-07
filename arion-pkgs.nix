let
  sources = import ./nix/sources.nix {};
  nixpkgs = import sources.nixpkgs {};
in
  nixpkgs # { system = "x86_64-linux"; }
