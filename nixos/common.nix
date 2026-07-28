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
  #   ASPETTO E FONT
  # ==========================================
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Hack Nerd Font" ];
      };
    };
  };

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

  # Abilita il portachiavi per salvare le password di Chrome/App
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true; # Interfaccia grafica opzionale per gestire le chiavi
  
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
  #   GESTIONE LOGIN E AMBIENTE GRAFICO
  # ==========================================
  # Spegniamo definitivamente l'ambiente GNOME e il suo Display Manager (GDM)
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.displayManager.gdm.enable = false;
  
  # Disattiviamo l'autologin testuale
  services.greetd.enable = false;

  # Accendiamo SDDM in modalità Wayland con motore grafico moderno (Qt6)
  services.displayManager.sddm.wayland.enable = true; # Manteniamo Wayland
  programs.silentSDDM = {
    enable = true;
    theme = "default";
  };

  # Hyprland (Wayland Tiling Window Manager principale)
  programs.hyprland.enable = true;

  # ==========================================
  #   SHELL, TERMINALE E ALIAS
  # ==========================================
  programs.zsh.enable = true;
  programs.tmux.enable = true;

  environment.shellAliases = {
    # Salva tutto su GitHub in un colpo solo (Add + Commit + Push)
    carica = "(cd ~/.dotfiles && git add . ; git commit -m 'Salvataggio automatico' ; git push)";
    scarica = "(cd ~/.dotfiles && git pull)";
  };

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

  # ==========================================
  #   PACCHETTI SOFTWARE GLOBALI
  # ==========================================
  environment.systemPackages = with pkgs; [
    # --- INTERNET E COMUNICAZIONE ---
    google-chrome             # Browser web
    discord                   # Chat e chiamate vocali
    #whatsapp

    # --- AMBIENTE TILING (Wayland/Hyprland) ---
    kitty                     # Emulatore di terminale super veloce
    wl-clipboard              # Gestione del copia/incolla su Wayland
    awww                      # Gestione degli sfondi
    wofi                      # Ricercatore delle applicazioni
    tmux
    starship
    papirus-icon-theme        # Utile per le icone (es wofi)
    pavucontrol               # Gestore visivo per Audio
    networkmanagerapplet      # Gestore visivo per Rete
    ags                       # Per vari widget etc...
    hyprlock                  # Per interfaccia di blocco schermo

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
    brightnessctl             # Per regolare la luminosità dello schermo
    hyfetch                   # Per vedere informazioni sul pc
    grim                      # Per catturare screenshot
  ];
}
