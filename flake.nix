{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-23-05.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-23-05,
    home-manager,
    pre-commit-hooks,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          mihomo-tui = final.callPackage ./pkgs/mihomo-tui.nix {};
        })
      ];
    };
    mkHome = username:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          {home.username = username;}
          {
            _module.args.pkgs-23-05 = nixpkgs-23-05.legacyPackages.${system};
          }
        ];
      };
    pre-commit-check = pre-commit-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        alejandra.enable = true;
      };
    };
  in {
    homeConfigurations = {
      "ulysses" = mkHome "ulysses";
      "xiyao" = mkHome "xiyao";
      "admin" = mkHome "admin";
    };

    formatter.${system} = pkgs.alejandra;

    checks.${system}.pre-commit = pre-commit-check;

    devShells.${system}.default = pkgs.mkShell {
      inherit (pre-commit-check) shellHook;
    };
  };
}
