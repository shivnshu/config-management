{ config, pkgs, ... }:

{

	services.xserver.enable = true;
	services.xserver.autorun = true;
	services.xserver.videoDrivers = ["xf86-video-nouveau"];
  #services.xserver.videoDrivers = [ "nvidia" ];

	services.xserver.layout = "us";

	services.xserver.windowManager.i3.enable = true;
	#services.xserver.windowManager.default = "xmonad";
	#services.xserver.windowManager.xmonad.extraPackages = hpkgs: [
		#hpkgs.taffybar
		#hpkgs.xmonad-contrib
		#hpkgs.xmonad-extras
	#];

	services.xserver.desktopManager.xterm.enable = false;
	services.xserver.desktopManager.default = "none";

	# services.xserver.displayManager.slim.enable = true;
	# services.xserver.displayManager.slim.defaultUser = "shivnshu";
	services.xserver.displayManager.lightdm.enable = true;

	# TouchScreen
	# services.xserver.wacom.enable = true;
	
	# TouchPad
	services.xserver.libinput.enable = true;
	services.xserver.libinput.tapping = true;

	# Backlight
	programs.light.enable = true;
}
