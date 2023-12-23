# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, username, name, hostname, timezone, locale, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Kernel modules
  boot.initrd.kernelModules = [ "zfs" ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.timeout = 5;

  # Specify your ZFS pool and root dataset
  boot.initrd.zfs.forceImportRoot = true;
  boot.supportedFilesystems = [ "zfs" ];

  # Networking
  networking.hostId = hostid; # Generate hostid with command <head -c 8 /etc/machine-id>
  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true; # Use networkmanager

  # Timezone and locale
  time.timeZone = timezone; # time zone
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  # Ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # I'm sorry Stallman-taichou
  nixpkgs.config.allowUnfree = true;

  # Garbage collection
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
  
  # Auto update 
  system = {
    autoUpgrade = {
      enable = true;
      dates = "daily";
      channel = "https://nixos.org/channels/nixos-23.11";
    };
    stateVersion = "23.11";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.flatpak.enable = true; 

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # User account
  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    uid = 1000;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Terminal
    btop
    coreutils
    git
    killall
    lshw
    nano
    nix-tree
    pciutils
    ranger
    smartmontools
    tldr
    usbutils
    wget
    xdg-utils

    # Video/Audio
    alsa-utils
    feh
    ffmpeg
    mediainfo
    mpv
    pavucontrol
    pipewire
    pulseaudio
    vlc

    # Apps
    firefox
    paperless-ngx
    qbittorrent
    wallabag
    yt-dlp

    # File Management
    gnome.file-roller
    okular
    pcmanfm
    rsync
    unzip
    unrar
    zip
  ];

  services = {
      cockpit = {
        enable = true;
        openFirewall = false;
        port = 9090;
      };

      plex = {
        enable = true;
        openFirewall = true;
      # dataDir = "/var/lib/plex";
      };

      tautulli = {
        enable = true;
        openFirewall = false;
        port = 8181;
      # dataDir = "/var/lib/plexpy";
      };

      sonarr = {
        enable = true;
        openFirewall = false;
      # dataDir = "/var/lib/sonarr/.config/NzbDrone";
      };

      radarr = {
        enable = true;
        openFirewall = false;
        # dataDir = "/var/lib/radarr/.config/Radarr";
      };

      bazarr = {
        enable = true;
        openFirewall = false;
        listenPort = 6767;
      };

      prowlarr = {
        enable = true;
        openFirewall = false;
      # port = 9696;
      };

      ombi = {
        enable = true;
        openFirewall = false;
        port = 5000;
        # dataDir = "/var/lib/ombi";
      };

      lidarr = {
        enable = true;
        openFirewall = false;
        # dataDir = "/var/lib/lidarr/.config/Lidarr";
      };

      #calibre-server = {
      #  enable = true;
      #};
  };
}
