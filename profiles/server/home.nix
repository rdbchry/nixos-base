{ config, lib, pkgs, stdenv, fetchurl, nix-doom-emacs, stylix, username, email, dotfilesDir, theme, wm, browser, editor, spawnEditor, term, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/"+username;

  programs.home-manager.enable = true;

  imports = [
              nix-doom-emacs.hmModule
              stylix.homeManagerModules.stylix
              (./. + "../../../user/wm"+("/"+wm+"/"+wm)+".nix") # My window manager selected from flake
              ../../user/shell/sh.nix # My zsh and bash config
              ../../user/shell/cli-collection.nix # Useful CLI apps
              ../../user/app/doom-emacs/doom.nix # My doom emacs config
              ../../user/app/ranger/ranger.nix # My ranger file manager config
              ../../user/app/git/git.nix # My git config
              (./. + "../../../user/app/browser"+("/"+browser)+".nix") # My default browser selected from flake
              ../../user/app/flatpak/flatpak.nix # Flatpaks
              ../../user/style/stylix.nix # Styling and themes for my apps
              ../../user/lang/cc/cc.nix # C and C++ tools
              ../../user/hardware/bluetooth.nix # Bluetooth
            ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core
    zsh
    alacritty
    librewolf
    dmenu
    rofi
    git
    syncthing

    # Office
    libreoffice-fresh
    mate.atril
    xournalpp
    glib
    newsflash
    gnome.nautilus
    gnome.gnome-calendar
    gnome.seahorse
    gnome.gnome-maps
    texliveSmall

    # Media
    gimp-with-plugins
    pinta
    krita
    inkscape
    musikcube
    vlc
    mpv
    yt-dlp
    #freetube
    cura
    movit
    mediainfo
    libmediainfo
    mediainfo-gui
    audio-recorder

    # Various dev packages
    texinfo
    libffi zlib
    nodePackages.ungit
  ];

  services.syncthing.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_VM_DIR = "${config.home.homeDirectory}/Machines";
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_PODCAST_DIR = "${config.home.homeDirectory}/Media/Podcasts";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    EDITOR = editor;
    SPAWNEDITOR = spawnEditor;
    TERM = term;
    BROWSER = browser;
  };

}
