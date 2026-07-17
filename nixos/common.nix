# ==============================================================================
# CONFIGURAZIONE CONDIVISA: IDENTITÀ, SOFTWARE E AMBIENTE
# (Tutto ciò che c'è qui si applicherà magicamente a tutti i PC)
# ==============================================================================

{ config, pkgs, ... }:

{
  # ==========================================
  #   LOCALIZZAZIONE E LINGUA
  # ==========================================
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "it_IT.UTF-8";
  
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Tastiera per ambiente grafico e terminale puro
  services.xserver.xkb = {
    layout = "it";
    variant = "";
  };
  console.keyMap = "it2";


  # ==========================================
  #   UTENTI E PERMESSI
  # ==========================================
  users.users."elias" = {
    isNormalUser = true;
    description = "elias";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  
  # Permette di installare software proprietario (es. Chrome, Discord)
  nixpkgs.config.allowUnfree = true;


  # ==========================================
  #   RETE, STAMPANTI E AUDIO
  # ==========================================
  networking.networkmanager.enable = true;
  services.printing.enable = true;

  # Motore Audio (Pipewire è lo standard moderno su Linux)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # ==========================================
  #   AMBIENTI DESKTOP E SHELL
  # ==========================================
  # Hyprland (Wayland Tiling Window Manager principale)
  programs.hyprland.enable = true;

  # GNOME (Interfaccia classica / Piano di riserva)
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [ gnome-console gnome-terminal ];

  # Shell e Terminal Multiplexer
  programs.zsh.enable = true;
  programs.tmux.enable = true;


  # ==========================================
  #   SVILUPPO E GESTIONE SISTEMA
  # ==========================================
  # Esegue file precompilati su NixOS (molto utile per chi programma)
  programs.nix-ld.enable = true; 
  
  # Variabili d'ambiente per il compilatore C/C++
  environment.variables = {
    C_INCLUDE_PATH = "${pkgs.glibc.dev}/include";
    CPLUS_INCLUDE_PATH = "${pkgs.glibc.dev}/include";
  };
  
  # Autopulizia di sistema (svuota /boot dalle vecchie generazioni)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

# --- SCORCIATOIE DA TERMINALE (ALIAS) ---
  environment.shellAliases = {
    # Per aggiornare i sistemi senza ricordare il comando lungo
    aggiorna-desktop = "sudo nixos-rebuild switch --flake ~/.dotfiles/nixos#desktop";
    aggiorna-laptop = "sudo nixos-rebuild switch --flake ~/.dotfiles/nixos#laptop";
    
    # Salva tutto su GitHub in un colpo solo (Add + Commit + Push)
    carica = "(cd ~/.dotfiles/nixos && git add . ; git commit -m 'Salvataggio automatico' ; git push)";
    scarica = "(cd ~/.dotfiles/nixos && git pull)";
    
  };

  # ==========================================
  #   PACCHETTI SOFTWARE GLOBALI
  # ==========================================
  environment.systemPackages = with pkgs; [
    
    # --- INTERNET E COMUNICAZIONE ---
    google-chrome             # Browser web
    discord                   # Chat e chiamate vocali
    
    # --- AMBIENTE TILING (Wayland/Hyprland) ---
    kitty                     # Emulatore di terminale super veloce
    wl-clipboard              # Gestione del copia/incolla su Wayland
    swaybg                 # Gestione degli sfondi
    wofi                      # Rierctore delle applicazioni
    waybar                    # Barra delle applicazioni
    tmux
    starship

    # --- PROGRAMMAZIONE E TERMINALE (Strumenti base) ---
    neovim                    # Editor di testo avanzato da terminale
    git                       # Controllo di versione per il codice
    nodejs                    # Runtime JavaScript (spesso richiesto da plugin Neovim)
    tree-sitter               # Parser per evidenziare la sintassi su Neovim
    
    # --- LINGUAGGIO C/C++ ---
    gcc                       # Compilatore standard GNU
    clang-tools               # Strumenti di analisi del codice (LSP)
    glibc.dev                 # Librerie C di base
    gnumake                   # Strumento "make" per automatizzare la compilazione
    
    # --- UTILITY DI RICERCA E GESTIONE FILE ---
    wget                      # Per scaricare file da internet da riga di comando
    unzip                     # Per estrarre gli archivi .zip
    ripgrep                   # Motore di ricerca testo super veloce (sostituto di grep)
    fd                        # Sostituto moderno e veloce per trovare i file
    
    # --- ESTENSIONI GNOME ---
    gnomeExtensions.forge     # Aggiunge il Tiling a GNOME
    gnome-extension-manager   # App per gestire le estensioni
  ];
}
