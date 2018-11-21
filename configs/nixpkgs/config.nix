{
    nix.nixPath = ["/home/shivnshu/Projects" "nixos-config=/etc/nixos/configuration.nix"];
    nix.binaryCaches = ["http://hydra.nixos.org/" "http://cache.nixos.org/"];
    allowUnfree = true;

    packageOverrides = super: let self = super.pkgs; in rec {

        updateFile = super.writeScriptBin "upd"
        ''
            #!/${super.bashInteractive}/bin/bash
            nix-env -f '<nixpkgs>' -i all
        '';

        quickAccess = super.writeScriptBin "vv"
        ''
            #!/${super.bashInteractive}/bin/bash
            if [ $# -lt 1 ]; then
                ${super.neovim}/bin/nvim `nix-instantiate --eval -E '<nixpkgs>'`/pkgs/top-level/all-packages.nix
            else
                name=$(grep -oP "^\s*$1\s*=\s*.*?\.\.(\/[\w\.-]*)*"  \
                ~/Projects/nixpkgs/pkgs/top-level/all-packages.nix | \
                grep -oP '\.\.(\/[\w\.-]*)*''$')
                grep -P '\.nix''$' <<< $name
                if [[ "$?" -eq "0" ]]; then
                    ${super.neovim}/bin/nvim "`nix-instantiate --eval -E '<nixpkgs>'`/pkgs/top-level/$name"
                else
                    ${super.neovim}/bin/nvim "`nix-instantiate --eval -E '<nixpkgs>'`/pkgs/top-level/$name/default.nix"
                fi
            fi
        '';

        rxvt_unicode-with-plugins = super.rxvt_unicode-with-plugins.override { plugins = [ self.urxvt_perls ]; };

        all = with self; buildEnv {
            name = "all";
            paths = [
              usbutils gdb xdg_utils
              neovim rofi vlc firefox emacs compton
              termite tmux
              gnupg gnome3.gedit deluge evince tcpdump
              virtmanager scrot
              pamixer
              volnoti
              pavucontrol
              weechat
              imagemagick
              calibre
              xsel
              gparted
              iotop
              inetutils
              gnumake
              tree
            ] 
            ++ my_network_tools
            ++ my_fancy_stuff
            ++ my_overriden_tools;
        };

        my_network_tools = with self; [
            wirelesstools nmap dnsutils
        ];

        my_fancy_stuff = with self; [
            cowsay lolcat figlet sl
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
                                pylookup
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

        overriden_scala = self.scala.override { jre = self.jre8; };
		my_scala_env = with self; buildEnv {
			name = "my_scala_env";
			paths = [
						overriden_scala
                        sbt
					];
		};

		my_go_env = with self; buildEnv {
			name = "my_go_env";
			paths = [
                        go
                        gocode
                        godef
					];
		};

    };

}
