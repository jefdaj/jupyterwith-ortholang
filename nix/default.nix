{ config ? { }, overlays ? [ ] }:

let
  sources = import ./sources.nix {};
  defaultOverlays = [
    (import ./haskell-overlay.nix)
    (import ./python-overlay.nix)
  ];
  overlaysAll = defaultOverlays ++ overlays;
in
import sources.nixpkgs { config = { allowUnsupportedSystem = true; }; overlays = overlaysAll; }
