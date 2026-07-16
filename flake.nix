{
  description = "La mia configurazione NixOS condivisa";

  inputs = {
    # Qui diciamo a NixOS da dove scaricare i pacchetti
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      
      # Questo è il profilo per il tuo PC fisso
      fisso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Diciamo al Flake di leggere i file che abbiamo appena copiato
          ./pc-fisso/configuration.nix
        ];
      };

    };
  };
}
