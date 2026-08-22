<div align="center" id="nixos-dotfiles">

# ❄️ NixOS Dotfiles

**Reproducible · Declarative · Beautiful · Dendritic Architecture**

<a href="https://github.com/NixOS/nixpkgs"><img alt="NixOS" src="https://img.shields.io/badge/NixOS-26.05-5277C3?style=for-the-badge&logo=nixos&logoColor=white" /></a>
<a href="https://github.com/nix-community/home-manager"><img alt="Home Manager" src="https://img.shields.io/badge/Home_Manager-26.05-7EBAE4?style=for-the-badge&logo=nixos&logoColor=white" /></a>
<a href="https://invent.kde.org/plasma/plasma-desktop"><img alt="KDE Plasma" src="https://img.shields.io/badge/KDE_Plasma-6-1D99F3?style=for-the-badge&logo=kde&logoColor=white" /></a>
<a href="https://hyprland.org/"><img alt="Hyprland" src="https://img.shields.io/badge/Hyprland-Wayland-55B1E6?style=for-the-badge&logo=hyprland&logoColor=white" /></a>
<a href="https://github.com/catppuccin/catppuccin"><img alt="Catppuccin" src="https://img.shields.io/badge/Catppuccin-Mocha-F5C2E7?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMjgiIGhlaWdodD0iMTI4Ij48cGF0aCBkPSJNNjQgMTI4YzM1LjM0NiAwIDY0LTI4LjY1NCA2NC02NFM5OS4zNDYgMCA2NCAwIDAgMjguNjU0IDAgNjRzMjguNjU0IDY0IDY0IDY0eiIgZmlsbD0iIzMxMzI0NCIvPjwvc3ZnPg==" /></a>

</div>

## 📁 Structure (Dendritic Pattern)

This repository follows the **dendritic pattern** using [`flake-parts`](https://github.com/hercules-ci/flake-parts) and [`import-tree`](https://github.com/vic/import-tree) to auto-discover and load modules into a clean tree structure.

```
dotfiles/
├── flake.nix                 # 🎯 Minimal entrypoint (flake-parts + import-tree)
├── assets/                   # 🖼️ Media & static assets (wallpapers, images)
├── config/                   # ⚙️ Non-Nix dotfiles & standalone configs (Hyprland, Mako icons...)
├── modules/                  # 🌲 Dendritic module tree (auto-imported by import-tree)
│   ├── apps/                 # 🚀 App modules (Alacritty, Fish, VS Code, Waybar, QuickShell, Rofi...)
│   ├── core/                 # ⚙️ System core modules (audio, boot, fonts, hardware, kernel, nix, users)
│   ├── de/                   # 🖥️ Desktop environments (Hyprland, KDE Plasma 6)
│   ├── hosts/                # 💻 Per-machine host definitions (desktop, laptop, wsl, iso)
│   ├── lib/                  # 🛠️ Helper utilities (utils.nix)
│   ├── scripts/              # 📜 System scripts (mountfs.sh, wallpapers.sh)
│   ├── nixpkgs.nix           # 📦 Nixpkgs instantiation & overlay configs
│   ├── shared.nix            # 🔗 Shared options & directory path definitions
│   └── systems.nix           # 🏗️ Machine configurations (nixosConfigurations & homeConfigurations)
├── overlays/                 # 🔄 Custom Nixpkgs overlays (microsoft-edge, open-scq30, xournalpp)
└── packages/                 # 📦 Custom Nix derivations (gsr-ui, flydigictl, spotify-adblock...)
```

## 📦 What's Included

### 🖥️ Desktop Environments & Window Managers
- **Hyprland** (Wayland) – Lua-based configuration with QuickShell, SwayNC, Waybar, & Rofi themes
- **KDE Plasma 6** (Wayland)

### 💻 Host Configurations
- `desktop-nixos` – Main desktop workstation configuration
- `laptop-nixos` – Mobile laptop setup
- `wsl-nixos` – Windows Subsystem for Linux configuration
- `iso-nixos` – Live installer image configuration

### 🎨 Theme
Catppuccin Mocha - applied throughout the system with custom overrides

### 🐚 Shell & Environment
Fish + Starship + zoxide + eza + direnv + devenv

### 🖼️ Terminals
Foot, Alacritty

## 🙏 Credits

Structure inspired by the dendritic pattern & [Keenan Weaver's nix-config](https://github.com/keenanweaver/nix-config)

<div align="center">

**[⬆ Back to Top](#nixos-dotfiles)**

Made with ❄️ and ☕ by [@AhmedAmrNabil](https://github.com/AhmedAmrNabil)

</div>
