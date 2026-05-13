<div align="center" id="nixos-dotfiles">

# ❄️ NixOS Dotfiles

**Reproducible · Declarative · Beautiful**

<a href="https://github.com/NixOS/nixpkgs"><img alt="NixOS" src="https://img.shields.io/badge/NixOS-25.11-5277C3?style=for-the-badge&logo=nixos&logoColor=white" /></a>
<a href="https://github.com/nix-community/home-manager"><img alt="Home Manager" src="https://img.shields.io/badge/Home_Manager-25.11-7EBAE4?style=for-the-badge&logo=nixos&logoColor=white" /></a>
<a href="https://invent.kde.org/plasma/plasma-desktop"><img alt="KDE Plasma" src="https://img.shields.io/badge/KDE_Plasma-6-1D99F3?style=for-the-badge&logo=kde&logoColor=white" /></a>
<a href="https://github.com/catppuccin/catppuccin"><img alt="Catppuccin" src="https://img.shields.io/badge/Catppuccin-Mocha-F5C2E7?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMjgiIGhlaWdodD0iMTI4Ij48cGF0aCBkPSJNNjQgMTI4YzM1LjM0NiAwIDY0LTI4LjY1NCA2NC02NFM5OS4zNDYgMCA2NCAwIDAgMjguNjU0IDAgNjRzMjguNjU0IDY0IDY0IDY0eiIgZmlsbD0iIzMxMzI0NCIvPjwvc3ZnPg==" /></a>

</div>

## 📁 Structure

```
dotfiles/
├── flake.nix                 # 🎯 Entry point
├── hosts/                    # 💻 NixOS per-machine configs
│   ├── desktop/
│   ├── laptop/
│   └── wsl/
├── modules/                  # 🔧 NixOS modules
│   ├── apps/                 # docker, steam, obs, etc.
│   ├── core/                 # boot, kernel, users, nix
│   └── de/                   # 🖥️ KDE, Hyprland
├── home/                     # 🏠 Home Manager config
│   ├── apps/                 # fish, vscode, starship, etc.
│   └── profiles/             # desktop, laptop, wsl
├── config/                   # ⚙️ Non-nix configs (hyprland, rofi, mako)
├── packages/                 # 📦 Custom packages
└── overlays/                 # 🔄 Nixpkgs overlays
```

## 📦 What's Included

### 🖥️ Desktop Environment
KDE Plasma 6 (Wayland)

### 🎨 Theme
Catppuccin Mocha - applied throughout the system with custom overrides

### 🐚 Shell
Fish + Starship + zoxide + eza + direnv

### 🖼️ Terminals
Foot, Alacritty

## 🙏 Credits

Structure inspired by [Keenan Weaver's nix-config](https://github.com/keenanweaver/nix-config)

<div align="center">

**[⬆ Back to Top](#nixos-dotfiles)**

Made with ❄️ and ☕ by [@AhmedAmrNabil](https://github.com/AhmedAmrNabil)

</div>

