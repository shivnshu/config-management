{
    nix.nixPath = ["nixos-config=/etc/nixos/configuration.nix"];
    nix.binaryCaches = ["http://hydra.nixos.org/" "http://cache.nixos.org/"];
    allowUnfree = true;

    packageOverrides = super: let self = super.pkgs; in rec {

        rxvt_unicode-with-plugins = super.rxvt_unicode-with-plugins.override { plugins = [ self.urxvt_perls ]; };

        all = self.buildEnv {
            name = "all";
            paths = with self; [
              usbutils weechat gdb xdg_utils
              neovim rofi vlc firefox emacs compton
              termite tmux python3 python36Packages.ipython
              gnupg gnome3.nautilus gnome3.gedit deluge evince tcpdump
              virtmanager scrot
              pamixer
              volnoti
              pavucontrol
              imagemagick
              calibre
              xsel
            ] 
            ++ my_network_tools
            ++ my_overriden_tools;
        };

        my_network_tools = with self; [
            wirelesstools nmap dnsutils
        ];

        my_overriden_tools = [
            rxvt_unicode-with-plugins 
        ];

    };

}
