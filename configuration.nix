{ config, pkgs, ... }:



#let
  # Import the 'nixos-25.05' channel you added via the command line
#stable = import <stable> {


    # You can pass arguments like this if needed
    # config = config.nixpkgs.config;
#  };
#in


{
  imports =
    [ # Include the results of the hardware scan.
#      /etc/nixos/hardware-configuration.nix
./hardware-configuration.nix 
     ./vm.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;



nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

environment.sessionVariables = {
  FLAKE = "/home/oto/nixos-config"; # Adjust user if needed
};

  ##############################################################################
  # Networking & Host
  ##############################################################################
  networking = {
    hostName             = "oto";
    networkmanager.enable = true;
  };

  ##############################################################################
  # Localization & Time
  ##############################################################################
  time.timeZone           = "Europe/Riga";
  i18n.defaultLocale      = "en_US.UTF-8";
  i18n.extraLocaleSettings  = {
    LC_ADDRESS        = "lv_LV.UTF-8";
    LC_IDENTIFICATION = "lv_LV.UTF-8";
    LC_MEASUREMENT    = "lv_LV.UTF-8";
    LC_MONETARY       = "lv_LV.UTF-8";
    LC_NAME           = "lv_LV.UTF-8";
    LC_NUMERIC        = "lv_LV.UTF-8";
    LC_PAPER          = "lv_LV.UTF-8";
    LC_TELEPHONE      = "lv_LV.UTF-8";
    LC_TIME           = "lv_LV.UTF-8";
  };

  ##############################################################################
  # Display Manager & Desktop
  ##############################################################################
  services.xserver = {
    enable = true;
    xkb = { layout = "lv"; variant = "apostrophe"; };

#desktopManager = {
#xterm.enable = false;
#xfce.enable = true;
#};


 };


  # Enable the COSMIC login manager
services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
services.desktopManager.cosmic.enable = true;


  ##############################################################################
  # Sound & Printing
  ##############################################################################
 # services.printing.enable = true;
services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};

#Printers
services.printing = {
  enable = true;
  drivers = with pkgs; [
    cups-filters
    cups-browsed
    epson-201401w
  ];
};




  # Correct way to disable PulseAudio and enable PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;




#  services.pipewire = {
#    enable = true;
#    alsa.enable = true;
#    alsa.support32Bit = true;
#    pulse.enable = true;
#    wireplumber = {
#      enable = true;
#      configPackages = [
#        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-mitigate-annoying-profile-switch.conf" ''
#          wireplumber.settings = {
#            bluetooth.autoswitch-to-headset-profile = false
#          }
#
#          monitor.bluez.properties = {
#            bluez5.roles = [ a2dp_sink a2dp_source ]
#          }
#        '')
#      ];
#    };
#  };


  # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
#  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };



  ##############################################################################
  # Flatpak & Bluetooth
  ##############################################################################
  services.flatpak.enable      = true;
  xdg.portal = {
  enable = true;
  extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
};  



hardware.graphics = {
  enable = true;
  enable32Bit = true; # For Steam/Wine
};



hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      FastConnectable = true;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
    };
  };
};





  ##############################################################################
  # User "oto"
  ##############################################################################
  users.users.oto = {
    isNormalUser = true;
    description  = "oto";
    extraGroups  = [ "networkmanager" "wheel" ];
    packages     = with pkgs; [

    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    font-awesome
    ipafont
    noto-fonts-color-emoji
  ];


  programs.steam.enable    = true;
  
  
  programs.firefox = {
    enable = true;
    preferences = {    "widget.gtk.libadwaita-colors.enabled" = false;
      };
  };
  

  ##############################################################################
  # System-wide Packages & Settings
  ##############################################################################
  services.power-profiles-daemon.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  #environment.variables = {
  #  AMD_DEBUG = "notiling";
  #};

  environment.systemPackages = with pkgs; [
    mission-center
    tty-clock
    bc
    ffmpeg
    pipx
    powertop

      # Productivity & Office
      obsidian
      # Terminal & Shell
      kitty fastfetch
      # Sync & Storage
      syncthing yazi
      # Multimedia
      ani-cli mpv vlc shotwell cava
      # Browsers
     # Development & Dat
      # System Utilities & Monitoring
      gparted networkmanagerapplet usbguard
      pciutils usbutils
      steam-run zip unzip p7zip zsh tldr
      git
      mpd
      rmpc
      lrcget
      iwd
      os-prober
      btop
libreoffice-fresh








nh

    (pkgs.rstudioWrapper.override {
      packages = with pkgs.rPackages; [
        tidyverse
        MatchIt
        cobalt
        broom
        modelsummary
        sandwich
        snakecase
        Rcmdr
        sem
        rgl
        multcomp
        markdown
        lmtest
        leaps
        aplpack
        gbm
        writexl

optmatch
RItools
ggplot2
dplyr
Matching
rgenoud

      ];
    })
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05"; # Did you read the comment?

}



