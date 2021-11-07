# Example of a Jupyter server with OrthoLang 0.9.5,
# as well as Python + R with custom packages
# Usage: nix-shell --command 'jupyter lab'

let
  jupyter = import ./default.nix {};

  python = jupyter.kernels.iPythonWith {
    name = "shell.nix";
    packages = p: with p; [ numpy ];
  };

  r = jupyter.kernels.iRWith {
    name = "shell.nix";
    packages = p: with p; [ p.tidyverse ];
  };

  # ortholang is a monolithic program with no user-installable packages so far
  # you can optionally add a name here though
  ortholang = jupyter.kernels.ortholangKernel {};

  jupyterEnvironment = jupyter.jupyterlabWith {
    kernels = [ python r ortholang ];
  };
in
  jupyterEnvironment.env
