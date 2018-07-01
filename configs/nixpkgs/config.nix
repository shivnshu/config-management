{
    nix.nixPath = ["nixos-config=/etc/nixos/configuration.nix"];
    nix.binaryCaches = ["http://hydra.nixos.org/" "http://cache.nixos.org/"];
    allowUnfree = true;

    packageOverrides = pkgs: rec {
        all = pkgs.buildEnv {
            name = "all";
            paths = with pkgs; [
              usbutils nmap weechat gdb xdg_utils
              neovim rofi vlc firefox emacs compton
              termite tmux python3 python36Packages.ipython
              gnupg gnome3.nautilus gnome3.gedit deluge evince tcpdump
              virtmanager scrot
              pamixer
              volnoti
              pavucontrol
            ] ++ my_network_tools;
        };

        my_network_tools = with pkgs; [
            wirelesstools nmap
        ];

    };

}
