{
  description = "La mia configurazione NixOS condivisa";

  inputs = {
    # Qui diciamo a NixOS da dove scaricare i pacchetti
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      # Profilo per il PC Fisso
      fisso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./desktop/configuration.nix ];
      };

      # NUOVO Profilo per il Portatile 
      portatile = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./laptop/configuration.nix ];
      };
    };
  };
}
