{ stdenv
, name ? null
, pkgs
, python3Packages
}:

let
  # TODO should we do more sanitizing here, or just expect users to be aware of paths?
  version = if isNull name
              then pinnedOrtholang.version
              else builtins.replaceStrings [" "] ["-"] name;

  sources         = import ../../nix/sources.nix {};
  pinnedNixpkgs   = import sources.nixpkgs {};
  pinnedOrtholang = import sources.ortholang; # TODO try a post-gitmodules version
  kernel = pinnedNixpkgs.callPackage sources.ortholang-jupyter-kernel rec {
    ortholang      = pinnedOrtholang;
    inherit pkgs;                     # note: not the old pinned version
    pythonPackages = python3Packages; # note: not the old pinned version
  };

  kernelFile = {
    argv = [
      "${kernel}/bin/ortholang_jupyter_kernel"
      "-f"
      "{connection_file}"
    ];
    codemirror_mode = "yaml"; # TODO what's this?
    display_name = "OrthoLang " + version;
    language = "ortholang";
    logo64 = "ortholang-64x64.png"; # TODO where is this used?
  };

  ortholangKernel = stdenv.mkDerivation rec {
    name = "ortholang-kernel-${version}";
    inherit version;
    src = ./ortholang-64x64.png; # TODO what's up with this part?
    # buildInputs = [];
    # TODO use name here?
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/ortholang_${version}
      cp $src $out/kernels/ortholang_${version}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ortholang_${version}/kernel.json
    '';
  };

in {
  spec = ortholangKernel;
  runtimePackages = [];
}
