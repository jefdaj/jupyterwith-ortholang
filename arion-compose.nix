{ pkgs, ... }:

let
  jupyter = import ./example.nix;

in {
  config.services = {

    jupyter = {
      service.useHostStore = true;
      service.command = [
        "${jupyter}/bin/jupyter-lab"
          "--allow-root"
          "--no-browser"
          "--log-level=DEBUG"
          "--ip=0.0.0.0"
      ];
      service.ports = [
        "8888:8888" # host:container
      ];
    };
  };
}
