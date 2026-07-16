{
  description = "La mia configurazione NixOS condivisa";

  inputs = {
    # Qui diciamo a NixOS da dove scaricare i pacchetti
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      # Profilo per il PC Fisso (questo ce l'hai già)
      fisso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./pc-fisso/configuration.nix ];
      };

      # NUOVO Profilo per il Portatile (Aggiungi questo!)
      portatile = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./portatile/configuration.nix ];
      };
    };
  };
}
