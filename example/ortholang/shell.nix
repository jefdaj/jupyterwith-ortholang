let
  jupyterLibPath = ../..;
  jupyter = import jupyterLibPath {};
  ortholang = jupyter.kernels.ortholangKernel {};

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [ ortholang ];
  };
in
  jupyterlabWithKernels.env
