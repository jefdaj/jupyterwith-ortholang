{ stdenv
, name ? "nixpkgs"
, pkgs
, python3Packages
}:

let
  # pinned ortholang kernel v0.9.5
  # TODO build kernel with current nixpkgs instead of matching ortholang?
  # TODO get all this from niv of course
  pinnedOrtholang = import           /home/jefdaj/myrepos/ortholang-jupyter-kernel/ortholang;
  pinnedNixpkgs   = import           /home/jefdaj/myrepos/ortholang-jupyter-kernel/ortholang/nixpkgs;
  kernel = pinnedNixpkgs.callPackage /home/jefdaj/myrepos/ortholang-jupyter-kernel rec {
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
    display_name = "OrthoLang - " + name; # TODO use version here?
    language = "ortholang";
    logo64 = "ortholang-64x64.png";
  };

  ortholangKernel = stdenv.mkDerivation rec {
    name = "ortholang-kernel-${kernel.version}"; # TODO use name here?
    inherit (kernel) version;
    logo = ./ortholang-64x64.png; # TODO what's up with this part?
    # buildInputs = [];
    # TODO use name here?
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/ortholang_${kernel.version}
      cp ${logo} $out/kernels/ortholang_${kernel.version}/ortholang-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ortholang_${kernel.version}/kernel.json
    '';
  };

in {
  spec = ortholangKernel;
  runtimePackages = [];
}
