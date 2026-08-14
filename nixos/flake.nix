{
  description = "La mia configurazione NixOS condivisa";

  inputs = {
    # Qui diciamo a NixOS da dove scaricare i pacchetti
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 

    # NUOVO: Aggiungiamo il repository di Caelestia
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # NUOVO: Aggiungiamo "inputs@" prima della parentesi graffa per catturare tutti gli inputs
  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {

      # Profilo per il PC Fisso
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # NUOVO: Passiamo gli inputs ai moduli di questo sistema
        specialArgs = { inherit inputs; };
        modules = [
            ./desktop/configuration.nix 
        ];
      };

      # Profilo per il Portatile 
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # NUOVO: Passiamo gli inputs ai moduli anche per il portatile
        specialArgs = { inherit inputs; };
        modules = [ 
            ./laptop/configuration.nix 
        ];
      };
    };
  };
}
