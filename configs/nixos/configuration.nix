# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./boot-configuration.nix
        ./network-configuration.nix
        ./X-configuration.nix
        ./multi-glibc-locale-paths.nix # For locale
    ];

    # Select internationalisation properties.
    i18n = {
        consoleFont = "Lat2-Terminus16";
        consoleKeyMap = "us";
        defaultLocale = "en_US.UTF-8";
    };

    # Set your time zone.
    time.timeZone = "Asia/Kolkata";

    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = with pkgs; [
        wget
        vim
        networkmanagerapplet
        blueman
        feh
        qemu
        termite
        ntfs3g
        gnome3.nautilus
        busybox
    ];

    programs.wireshark.enable = true;
    programs.wireshark.package = pkgs.wireshark;

    programs.bash.enableCompletion = true;
    programs.zsh.enable = true;

    # List services that you want to enable:
    services.emacs.enable = true;
    services.gnome3.gvfs.enable = true;
    services.udisks2.enable = true;

    # Set environments variables
    environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];

    # Sound
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.support32Bit = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;

    # Bluetooth
    hardware.bluetooth.enable = true;

    # Virtualisation
    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = false;
    virtualisation.libvirtd.enable = true;

    # MySQL
    #services.mysql.enable = true;
    #services.mysql.package = pkgs.mysql;
    #services.mysql.dataDir = "/var/db";

    #systemd.services.mysql.serviceConfig.Restart = "on-failure";
    #systemd.services.mysql.serviceConfig.RestartSec = "10s";

    #services.mysqlBackup.enable = true;
    #services.mysqlBackup.user = "shivnshu";
    #services.mysqlBackup.databases = [ "cs252" ];

    #services.mongodb.enable = true;
    #services.mongodb.bind_ip = "0.0.0.0";

    fonts = {
    	fontconfig = {
        antialias = true;
      };
      enableFontDir = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
      		dejavu_fonts
			powerline-fonts
			inconsolata
			liberation_ttf
			source-code-pro
    	];
	};

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.extraUsers.shivnshu = {
        isNormalUser = true;
        description = "Shivanshu Singh";
        uid = 1000;
        shell = pkgs.zsh;
        createHome = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "wireshark" "libvirtd" "docker" ];
    };

    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = "18.03"; # Did you read the comment?

}
