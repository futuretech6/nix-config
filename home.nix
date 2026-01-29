{
  config,
  pkgs,
  pkgs-23-05,
  ...
}: {
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    gitui
    bottom
    bat
    erdtree
    pre-commit
    autojump
    dust
    pkgs-23-05.nodePackages.prettier
    htop
    n-m3u8dl-re
    pay-respects
    mihomo-tui
  ];

  programs.home-manager.enable = true;

  home.activation.setupBashrc = config.lib.dag.entryAfter ["writeBoundary"] ''
        if ! grep -q "autojump.sh" $HOME/.bashrc 2>/dev/null; then
          cat >> $HOME/.bashrc << 'EOF'

    if [ -f "$HOME/.nix-profile/etc/profile.d/autojump.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/autojump.sh"
    fi
    EOF
        fi
  '';
}
