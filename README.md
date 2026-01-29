# Nix Home Manager Configuration

Personal Nix + Home Manager + Flake configuration repository

## Prerequisites

https://github.com/futuretech6/setup/blob/master/nix.md

## Usage

### Clone

```bash
git clone git@github.com:futuretech6/nix-config.git ~/.config/home-manager
```

### Initial Setup

```bash
nix run home-manager -- switch --flake ~/.config/home-manager#$(whoami)

# Install pre-commit hooks
cd ~/.config/home-manager && nix develop -c pre-commit install
```

### Update Dependencies

To update flake.lock:

```bash
nix flake update ~/.config/home-manager
home-manager switch --flake ~/.config/home-manager#$(whoami)
```

### Update Configuration

After modifying configuration files:

```bash
home-manager switch --flake ~/.config/home-manager#$(whoami)
```
