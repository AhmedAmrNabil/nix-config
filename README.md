<div align="center">

# ❄️ NixOS Dotfiles

**Reproducible · Declarative · Beautiful**

<a href="https://github.com/NixOS/nixpkgs"><img alt="NixOS" src="https://img.shields.io/badge/NixOS-25.11-5277C3?style=for-the-badge&logo=nixos&logoColor=white" /></a>
<a href="https://github.com/nix-community/home-manager"><img alt="Home Manager" src="https://img.shields.io/badge/Home_Manager-25.11-7EBAE4?style=for-the-badge&logo=nixos&logoColor=white" /></a>
<a href="https://github.com/hyprwm/Hyprland"><img alt="Hyprland" src="https://img.shields.io/badge/Hyprland-WM-00ADD8?style=for-the-badge&logo=wayland&logoColor=white" /></a>
<a href="https://invent.kde.org/plasma/plasma-desktop"><img alt="KDE Plasma" src="https://img.shields.io/badge/KDE_Plasma-6-1D99F3?style=for-the-badge&logo=kde&logoColor=white" /></a>
<a href="https://github.com/catppuccin/catppuccin"><img alt="Catppuccin" src="https://img.shields.io/badge/Catppuccin-Mocha-F5C2E7?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMjgiIGhlaWdodD0iMTI4Ij48cGF0aCBkPSJNNjQgMTI4YzM1LjM0NiAwIDY0LTI4LjY1NCA2NC02NFM5OS4zNDYgMCA2NCAwIDAgMjguNjU0IDAgNjRzMjguNjU0IDY0IDY0IDY0eiIgZmlsbD0iIzMxMzI0NCIvPjwvc3ZnPg==" /></a>

A modern NixOS configuration with flakes, Home Manager, and per-device profiles.  
Desktop & laptop get full GUI glory; WSL stays lean and headless.

</div>

---

## ✨ Features

| Category | Details |
|----------|---------|
| 🖥️ **Desktop Environment** | KDE Plasma 6 + Hyprland (Wayland) |
| 🎨 **Theme** | Catppuccin Mocha everywhere |
| 🐚 **Shell** | Fish + Starship prompt + zoxide |
| 📝 **Editor** | VS Code + Micro |
| 🎵 **Music** | Spicetify |
| 🖼️ **Terminal** | Foot + Alacritty |
| 🎮 **Hardware** | NVIDIA RTX + OpenTabletDriver |
| 📊 **Monitoring** | btop + fastfetch + cava |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        flake.nix                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │ desktop-nixos   │  │ laptop-nixos    │  │ wsl-nixos   │  │
│  └────────┬────────┘  └────────┬────────┘  └──────┬──────┘  │
└───────────┼────────────────────┼──────────────────┼─────────┘
            │                    │                  │
    ┌───────▼───────┐    ┌───────▼───────┐   ┌──────▼──────┐
    │ hosts/desktop │    │ hosts/laptop  │   │ hosts/wsl   │
    │ + GUI profile │    │ + GUI profile │   │ + headless  │
    └───────────────┘    └───────────────┘   └─────────────┘
```

### Profile System

| Profile | System Config | Home Config | GUI Apps |
|---------|---------------|-------------|----------|
| `desktop-nixos` | Full workstation | GUI + shared | ✅ All |
| `laptop-nixos` | Laptop tweaks | GUI + shared | ✅ All |
| `wsl-nixos` | WSL minimal | Shared only | ❌ None |

---

## 📦 What's Included

<details>
<summary><b>🖥️ GUI Applications</b> (Desktop/Laptop only)</summary>

- **Discord** (with OpenASAR + Vencord)
- **Spotify** (Spicetified with Catppuccin)
- **VS Code** with extensions
- **Microsoft Edge**
- **VLC**, **Xournal++**
- **Alacritty**, **Foot** terminals

</details>

<details>
<summary><b>🔧 CLI Tools</b> (All profiles)</summary>

- **fish** + **starship** - Modern shell experience
- **micro** - Terminal editor
- **eza** - Better `ls`
- **zoxide** - Smart directory navigation
- **btop** - Resource monitor
- **fastfetch** - System info
- **git**, **nodejs**, **pnpm**
- **nixfmt**, **nixd** - Nix tooling

</details>

<details>
<summary><b>🎨 Theming</b></summary>

Everything uses **Catppuccin Mocha**:
- Fish shell colors
- Alacritty & Foot terminals
- btop & cava
- VS Code
- Spotify (via Spicetify)
- Micro editor

</details>

---

## 🚀 Quick Start

### Prerequisites

- NixOS with flakes enabled, or
- Any Linux with Nix installed (for Home Manager only)

```nix
# Enable flakes in configuration.nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

### Installation

```bash
# Clone the repo
git clone https://github.com/AhmedAmrNabil/nixos-dotfiles.git ~/dotfiles
cd ~/dotfiles

# Verify flake outputs
nix flake show
```

### Apply Configuration

```bash
# NixOS + Home Manager combined (pick your profile)
sudo nixos-rebuild switch --flake .#desktop-nixos
sudo nixos-rebuild switch --flake .#laptop-nixos
sudo nixos-rebuild switch --flake .#wsl-nixos
```

> [!TIP]
> Home Manager is integrated as a NixOS module, so a single `nixos-rebuild switch`
> applies both system and user configuration changes.

### Fish Shell Shortcuts

Once configured, use this alias:

```bash
nrs   # → sudo nixos-rebuild switch --flake ~/dotfiles#(hostname)
```

---

## 📁 Repository Structure

```
dotfiles/
├── flake.nix                 # 🎯 Entry point - inputs & outputs
├── flake.lock                # 📌 Pinned dependencies
│
├── hosts/                    # 💻 Per-machine NixOS configs
│   ├── desktop/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── laptop/
│   │   └── ...
│   └── wsl/
│       └── configuration.nix
│
├── modules/                  # 🔧 NixOS + Home Manager modules
│   ├── apps/                 # Application configs (fish, vscode, btop, etc.)
│   ├── core/                 # Core system configuration
│   └── de/                   # Desktop environment configs
│
├── home/                     # 🏠 Home Manager profiles
│   ├── shared.nix            # Common to ALL profiles
│   └── profiles/
│       ├── desktop.nix       # GUI apps + shared
│       └── wsl.nix           # Shared only (headless)
│
├── config/                   # ⚙️ Config files not yet converted to Nix
│   ├── hypr/                 # Hyprland WM
│   ├── mako/                 # Notifications
│   └── rofi/                 # Launcher
│
├── pkgs/                     # 📦 Custom packages
│
└── overlays/                 # 🔄 Nixpkgs overlays
```



---

## ⚙️ Key Configuration Highlights

### Modular Architecture

Configuration is organized into composable modules:

| Module | Purpose |
|--------|--------|
| `modules/apps/` | Application configs (fish, vscode, btop, spotify, etc.) |
| `modules/core/` | Core system settings (networking, users, locale) |
| `modules/de/` | Desktop environments (Plasma, Hyprland) |



---

## 🛠️ Common Commands

```bash
# Update all flake inputs
nix flake update

# Build without switching (test)
sudo nixos-rebuild build --flake .#desktop-nixos

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# List generations
sudo nix-env --list-generations -p /nix/var/nix/profiles/system

# Garbage collection
sudo nix-collect-garbage -d
nix-collect-garbage -d  # user generations

# Check flake health
nix flake check
```

---

## 🔧 Customization

### Adding a New Program with config

1. Create `modules/apps/myprogram/default.nix`:
```nix
{ config, pkgs, ... }:
{
  programs.myprogram = {
    enable = true;
    # ... config options ...
  };
}
```

2. Import in `modules/apps/default.nix`.

### Adding an Application without config

Edit `home/profiles/desktop.nix`:
```nix
home.packages = with pkgs; [
  # Add your apps here
  firefox
  obsidian
];
```

### Creating a New Host

1. Copy an existing host: `cp -r /etc/nixos hosts/myhost/`
2. Add to `flake.nix`:
```nix
nixosConfigurations.myhost-nixos = mkSystem "myhost";
```
---

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes Guide](https://nixos.wiki/wiki/Flakes)
- [Catppuccin Theme](https://catppuccin.com/)

## 🙏 Credits

- Structure heavily inspired by [Keenan Weaver's nix-config](https://github.com/keenanweaver/nix-config)

---

<div align="center">

**[⬆ Back to Top](#️-nixos-dotfiles)**

Made with ❄️ and ☕ by [@AhmedAmrNabil](https://github.com/AhmedAmrNabil)

</div>
