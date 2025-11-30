{ config, pkgs, ... }:



{
  imports = [
    ./hardware-configuration.nix
    ./vm.nix
  ];

  # ============================================================================
  # BOOT
  # ============================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    NH_FLAKE = "/home/oto/nixos-config";    
  };

  # ============================================================================
  # NETWORKING & HOST
  # ============================================================================
  networking = {
    hostName = "oto";
    networkmanager.enable = true;
  };

  # ============================================================================
  # LOCALIZATION & TIME
  # ============================================================================
  time.timeZone = "Europe/Riga";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS      = "lv_LV.UTF-8";
    LC_IDENTIFICATION = "lv_LV.UTF-8";
    LC_MEASUREMENT  = "lv_LV.UTF-8";
    LC_MONETARY     = "lv_LV.UTF-8";
    LC_NAME         = "lv_LV.UTF-8";
    LC_NUMERIC      = "lv_LV.UTF-8";
    LC_PAPER        = "lv_LV.UTF-8";
    LC_TELEPHONE    = "lv_LV.UTF-8";
    LC_TIME         = "lv_LV.UTF-8";
  };

  services.xserver.xkb = {
    layout = "lv";
    variant = "apostrophe";
  };

  # ============================================================================
  # DESKTOP ENVIRONMENT (COSMIC)
  # ============================================================================
  services.xserver.enable = true; # X11 support
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # ============================================================================
  # AUDIO & MULTIMEDIA
  # ============================================================================
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # ============================================================================
  # HARDWARE & SERVICES
  # ============================================================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy.AutoEnable = true;
    };
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      epson-201401w
      #epson-escpr
    ];
  };
  
  hardware.sane.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.power-profiles-daemon.enable = true;
  services.flatpak.enable = true;

  # ============================================================================
  # USER CONFIGURATION
  # ============================================================================
  users.users.oto = {
    isNormalUser = true;
    description = "oto";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    font-awesome
    ipafont
  ];

  # ============================================================================
  # APPLICATIONS & PROGRAMS
  # ============================================================================
  programs.steam.enable = true;

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.gtk.libadwaita-colors.enabled" = false;
    };
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # --- Utilities ---
    bc
    btop
    ffmpeg
    git
    gparted
    mission-center
    nh
    nix-output-monitor
    nvd
    os-prober
    p7zip
    pciutils
    powertop
    steam-run
    tldr
    tty-clock
    unzip
    usbutils
    zip
    bat
    yazi
    syncthing
    

    # --- Terminal & Shell ---
    fastfetch
    kitty

    # --- Multimedia ---
    ani-cli
    cava
    lrcget
    mpd
    mpv
    rmpc
    shotwell
    vlc
    
    # --- Typing ---
    libreoffice-fresh
    obsidian

    # --- Data Science & R Environment ---
       R
        (pkgs.rstudioWrapper.override {
      packages = with pkgs.rPackages; [
        # Core
        tidyverse
        broom
        dplyr
        ggplot2
        markdown
        snakecase
        writexl

        # Modeling & Statistics
        Matching
        MatchIt
#        Rcmdr
        RItools
        aplpack
        cobalt
        gbm
        leaps
        lmtest
        modelsummary
        multcomp
        optmatch
        rgenoud
        rgl
        sandwich
        sem
      ];
    })
  ];

  system.stateVersion = "25.05";
}