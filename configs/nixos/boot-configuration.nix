{ config, pkgs, ... }:

{
	boot.loader.systemd-boot.enable = false;
  	boot.loader.efi.canTouchEfiVariables = true;
  	boot.loader.efi.efiSysMountPoint = "/boot/efi";
  	boot.loader.grub = {
    	enable = true;
    	device = "nodev";
    	version = 2;
    	efiSupport = true;
    	configurationLimit = 4;
        default = 0;
    	extraEntries =
      		''
      		menuentry "ArchLinux" {
        		# set root=(hd0,1)
        		# chainloader /efi/grub/grubx64.efi
        		set root='hd0,gpt3'
        		linux /vmlinuz-linux root=UUID=d964aa71-d90f-4f8e-af02-b08053c9f51f rw
        		initrd /intel-ucode.img /initramfs-linux.img
      		}
      		'';
  	};

}
