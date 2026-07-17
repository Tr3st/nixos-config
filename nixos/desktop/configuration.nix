# ==============================================================================
# CONFIGURAZIONE SPECIFICA: PC FISSO
# (Contiene solo bootloader, hardware e nome di questa specifica macchina)
# ==============================================================================

{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix  # I driver e dischi di questo PC
    ../common.nix                 # Il cuore del tuo sistema operativo (condiviso)
  ];

  # --- BOOTLOADER E KERNEL ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- SCORCIATOIE DA TERMINALE (ALIAS) ---
  environment.shellAliases = {
    apply = "sudo nixos-rebuild switch --flake ~/.dotfiles/nixos#desktop";
  };


  # --- IDENTITÀ HARDWARE DI QUESTO PC ---
  networking.hostName = "fisso-nixos";

  # --- VERSIONE DELLO STATO (NON TOCCARE) ---
  system.stateVersion = "26.05";
}
