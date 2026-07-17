# ==============================================================================
# CONFIGURAZIONE SPECIFICA: PORTATILE
# ==============================================================================

{ config, pkgs, ... }:

{

  imports = [ 
    ./hardware-configuration.nix  # I driver del portatile
    ../common.nix                 # Il cuore del tuo sistema operativo
  ];

  # --- BOOTLOADER ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  environment.shellAliases = {
    apply = "sudo nixxos-rebuild switch --flake ~/.dotfiles/nixos#laptop";
  };

  # --- IDENTITÀ HARDWARE ---
  networking.hostName = "portatile-nixos";

  # --- VERSIONE DELLO STATO ---
  system.stateVersion = "26.05"; # Usa la stessa che avevi nel file originale
}
