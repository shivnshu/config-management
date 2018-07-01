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
    ];

    # Select internationalisation properties.
    i18n = {
        consoleFont = "Lat2-Terminus16";
        consoleKeyMap = "us";
        defaultLocale = "en_US.UTF-8";
    };

    # Set your time zone.
    time.timeZone = "Asia/Kolkata";

    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = with pkgs; [
        wget
        vim
        networkmanagerapplet
        blueman
        feh
        qemu
        #rxvt_unicode
    ];

    programs.wireshark.enable = true;
    programs.wireshark.package = pkgs.wireshark;

    programs.bash.enableCompletion = true;
    programs.zsh.enable = true;

    # List services that you want to enable:
    services.emacs.enable = true;

    #systemd.user.services."urxvtd" = {
        #enable = true;
        #description = "rxvt unicode daemon";
        #wantedBy = [ "default.target" ];
        #path = [ pkgs.rxvt_unicode ];
        #serviceConfig.Restart = "always";
        #serviceConfig.RestartSec = 2;
        #serviceConfig.ExecStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -o";
    #};

    # Sound
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.support32Bit = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;

    # Bluetooth
    hardware.bluetooth.enable = true;

    # Virtualisation
    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = true;
    virtualisation.libvirtd.enable = true;

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
