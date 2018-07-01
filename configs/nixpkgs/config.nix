{
    nix.nixPath = ["nixos-config=/etc/nixos/configuration.nix"];
    nix.binaryCaches = ["http://hydra.nixos.org/" "http://cache.nixos.org/"];
    allowUnfree = true;

    packageOverrides = pkgs: rec {
        all = pkgs.buildEnv {
            name = "all";
            path = with pkgs; [
                usbutils nmap weechat gdb xdg_utils   
            ] ++ my_network_tools;
        };

        my_network_tools = with pkgs; [
            wirelesstools nmap
        ];

    };

}
