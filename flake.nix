{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
    home-manager,
    pre-commit-hooks,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    mkHome = username:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          {home.username = username;}
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
    };

    formatter.${system} = pkgs.alejandra;

    checks.${system}.pre-commit = pre-commit-check;

    devShells.${system}.default = pkgs.mkShell {
      inherit (pre-commit-check) shellHook;
    };
  };
}
