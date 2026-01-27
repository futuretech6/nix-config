{
  config,
  pkgs,
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
    nodePackages.prettier
    htop
    n-m3u8dl-re
    (let
      info =
        {
          "x86_64-linux" = {
            platform = "Linux-gnu-x86_64";
            hash = "sha256-xDWoFBniVhIEypNoi/WFeBWY5D8pEYUx2zLGA0Fdbnc=";
          };
          "aarch64-linux" = {
            platform = "Linux-gnu-arm64";
            hash = "";
          };
          "x86_64-darwin" = {
            platform = "Darwin-x86_64";
            hash = "";
          };
          "aarch64-darwin" = {
            platform = "Darwin-arm64";
            hash = "";
          };
        }.${
          pkgs.stdenv.hostPlatform.system
        };
    in
      pkgs.stdenv.mkDerivation rec {
        pname = "mihomo-tui";
        version = "0.3.0";
        src = pkgs.fetchurl {
          url = "https://github.com/potoo0/mihomo-tui/releases/download/v${version}/mihomo-tui-${info.platform}.tar.gz";
          inherit (info) hash;
        };
        sourceRoot = ".";
        installPhase = ''
          mkdir -p $out/bin
          cp mihomo-tui $out/bin/
          chmod +x $out/bin/mihomo-tui
        '';
      })
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
