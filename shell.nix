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

  # you can add a name, but there aren't packages like in python or R
  ortholang = jupyter.kernels.ortholangKernel {
    name = "pinned 0.9.5";
  };

  jupyterEnvironment = jupyter.jupyterlabWith {
    kernels = [ python r ortholang ];
  };
in
  jupyterEnvironment.env
