{
  description = "La mia configurazione NixOS condivisa";

  inputs = {
    # Qui diciamo a NixOS da dove scaricare i pacchetti
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
  };

inputs.ags.packages.${pkgs.system}.default.override {
  extraPackages = with inputs.ags.packages.${pkgs.system}; [
    hyprland
    mpris
    network
    wireplumber
    battery
    apps
    tray
  ];
}

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {

      # Profilo per il PC Fisso
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
            ./desktop/configuration.nix 
        ];
      };

      # NUOVO Profilo per il Portatile 
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
        ./laptop/configuration.nix 
        ];
      };
    };
  };
}
