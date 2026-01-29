{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "mihomo-tui";
  version = "0.3.0";

  src = let
    info =
      {
        "x86_64-linux" = {
          platform = "Linux-musl-x86_64";
          hash = "sha256-Glh7+EZmvD32RkLA2pLODW4gF4c5LFlo0K3fzoMVTkA=";
        };
        "aarch64-linux" = {
          platform = "Linux-musl-arm64";
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
        stdenv.hostPlatform.system
      };
  in
    fetchurl {
      url = "https://github.com/potoo0/mihomo-tui/releases/download/v${version}/mihomo-tui-${info.platform}.tar.gz";
      inherit (info) hash;
    };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp mihomo-tui $out/bin/
    chmod +x $out/bin/mihomo-tui
  '';
}
