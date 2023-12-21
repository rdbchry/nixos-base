#
#  Media Services: Plex, Torrenting and Automation
#

{ config, pkgs, ... }:

{
    services = {
        plex = {
            enable = true;
            openFirewall = true;
        #   dataDir = "/var/lib/plex";
        };

        tautulli = {
            enable = true;
            openFirewall = false;
            port = 8181;
        #   dataDir = "/var/lib/plexpy";
        };

        sonarr = {
            enable = true;
            openFirewall = false;
        #   dataDir = "/var/lib/sonarr/.config/NzbDrone";
        };

        radarr = {
            enable = true;
            openFirewall = false;
        #   dataDir = "/var/lib/radarr/.config/Radarr";
        };

        bazarr = {
            enable = true;
            openFirewall = false;
            listenPort = 6767;
        };

        prowlarr = {
            enable = true;
            openFirewall = false;
        #   port = 9696;
        };

        ombi = {
            enable = true;
            openFirewall = false;
            port = 5000;
        #   dataDir = "/var/lib/ombi";
        };

        lidarr = {
            enable = true;
            openFirewall = false;
        #   dataDir = "/var/lib/lidarr/.config/Lidarr";
        };

        #calibre-server = {
        #  enable = true;
        #};
    };
}