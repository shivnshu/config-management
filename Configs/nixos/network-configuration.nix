{ config, pkgs, ... }:

{
	networking = {
		hostName = "nixos";
		# wireless.enable = true;
		networkmanager.enable = true;
		#wireless.networks = {
		#	"RouteMe" = {
		#		psk = "myrouting";
		#	};
		#	"iitk" = {
		#	};
		#};
	};

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

  	# Open ports in the firewall.
 	# networking.firewall.allowedTCPPorts = [ ... ];
  	# networking.firewall.allowedUDPPorts = [ ... ];
  	# Or disable the firewall altogether.
  	# networking.firewall.enable = false;

}
