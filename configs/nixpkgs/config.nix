{
    nix.nixPath = ["nixos-config=/etc/nixos/configuration.nix"];
    nix.binaryCaches = ["http://hydra.nixos.org/" "http://cache.nixos.org/"];
    allowUnfree = true;

    packageOverrides = super: let self = super.pkgs; in rec {

        rxvt_unicode-with-plugins = super.rxvt_unicode-with-plugins.override { plugins = [ self.urxvt_perls ]; };

        all = with self; buildEnv {
            name = "all";
            paths = [
              usbutils weechat gdb xdg_utils
              neovim rofi vlc firefox emacs compton
              termite tmux
              gnupg gnome3.gedit deluge evince tcpdump
              virtmanager scrot
              pamixer
              volnoti
              pavucontrol
              imagemagick
              calibre
              xsel
              gparted
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

        my_python_env = with self; buildEnv {
            name = "my_python_env";
            paths = [
                        (with python36Packages; python.buildEnv.override {
                            extraLibs = [
                                ipython
                                psutil
                                setuptools
                                numpy
                                jedi
                                flake8
                                pytest
                                isort
                                yapf
                            ];
                        })
                        (with python27Packages; python.buildEnv.override {
                            extraLibs = [
                                psutil
                            ];
                        })
 
            ];
        };
    };

}
