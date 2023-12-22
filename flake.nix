{
  description = "Flake Me";

  outputs = { self, nixpkgs, home-manager, plasma-manager, ... } @inputs:
  let
    # ---- SYSTEM SETTINGS ---- #
    system = "x86_64-linux"; # system arch
    hostname = "phoenix"; # hostname
    hostid = "place-here"; # Generate hostid with command "head -c 8 /etc/machine-id"
    timezone = "Asia/Manila"; # select timezone
    locale = "en_US.UTF-8"; # select locale

    # ----- USER SETTINGS ----- #
    username = "mew"; # username
    name = "mew"; # name/identifier
    dotfilesDir = "~/.dotfiles"; # absolute path of the local repo

    # configure lib
    lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      system = lib.nixosSystem {
        inherit system;
        modules = [ (./. + "/profiles"+("/"+profile)+"/configuration.nix") ]; # load configuration.nix from selected PROFILE
        specialArgs = {
          # pass config variables from above
          inherit username;
          inherit name;
          inherit hostname;
          inherit hostid;
          inherit timezone;
          inherit locale;
          inherit inputs nixpkgs nixpkgs-unstable home-manager;
        };
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "nixpkgs";
      };
    };
}
