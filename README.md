# Nix Home Manager Configuration

个人 Nix + Home Manager + Flake 配置仓库

## 前置要求

https://github.com/futuretech6/setup/blob/master/nix.md

## 使用方法

### 克隆配置

```bash
git clone git@github.com:futuretech6/nix-config.git ~/.config/home-manager
cd ~/.config/home-manager
```

### 首次应用配置

```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#$(whoami)

# 安装 pre-commit hooks
nix develop -c pre-commit install
```

### 后续更新配置

修改配置文件或更新依赖后：

```bash
home-manager switch --flake ~/.config/home-manager#$(whoami)
```

## 临时安装软件包

Home Manager 管理的是声明式配置，如需临时安装软件包：

```bash
nix profile install nixpkgs#package-name
```

或一次性运行：

```bash
nix run nixpkgs#package-name --
```
