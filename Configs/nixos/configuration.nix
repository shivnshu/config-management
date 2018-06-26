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
        busybox
        binutils-unwrapped
		wget
        vim
        neovim
		taffybar
        wirelesstools
        usbutils
		networkmanagerapplet
        networkmanager-fortisslvpn
		blueman
		volnoti
		rofi
		pavucontrol
		feh
		vlc
		firefox
		emacs
		nmap
		compton
		termite
        tmux
        zsh
        python3
        python36Packages.ipython
        python36Packages.virtualenv
        python36Packages.setuptools
        python36Packages.jedi
        weechat
        gdb
        gnupg
        gnome3.gvfs # for nautilus trash
        gnome3.nautilus
        gnome3.gedit
        deluge
        iotop
        evince
        file
        bind
        tcpdump
        fping
        qemu
        virtmanager
        xdg_utils
        ettercap
	];

    nixpkgs.config.gnome3.gvfs.lightWeight = false;

	services.compton = {
		enable          = true;
		fade            = true;
		inactiveOpacity = "0.9";
		shadow          = true;
		fadeDelta       = 4;
	};

	nixpkgs.config.allowUnfree = true;

	nixpkgs.config.firefox.enableAdobeFlash = true;

    programs.wireshark.enable = true;
    programs.wireshark.package = pkgs.wireshark;

	programs.bash.enableCompletion = true;
    programs.zsh.enable = true;

	# List services that you want to enable:
    services.emacs.enable = true;
    services.gnome3.gvfs.enable = true;

	# Required for taffybar
	services.upower.enable = true;
	systemd.services.upower.enable = true;

	# Sound
	hardware.pulseaudio.enable = true;
	hardware.pulseaudio.support32Bit = true;
	hardware.pulseaudio.package = pkgs.pulseaudioFull;

	# Bluetooth
	hardware.bluetooth.enable = true;

    # Virtualisation
    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = false;
    virtualisation.libvirtd.enable = false;

	fonts.fonts = with pkgs; [
		powerline-fonts
	];

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.extraUsers.shivnshu = {
		isNormalUser = true;
		description = "Shivanshu Singh";
		uid = 1000;
		shell = pkgs.zsh;
		createHome = true;
		extraGroups = [ "wheel" "networkmanager" "audio" "wireshark" "libvirtd" "docker" ];
  	};
	# users.extraUsers.guest = {
	#   isNormalUser = true;
	#   uid = 1000;
	# };

	# This value determines the NixOS release with which your system is to be
	# compatible, in order to avoid breaking some software such as database
	# servers. You should change this only after NixOS release notes say you
	# should.
	system.autoUpgrade.enable = true;
  	system.autoUpgrade.channel = https://nixos.org/channels/nixos-18.03;
  	system.stateVersion = "18.03"; # Did you read the comment?

}
