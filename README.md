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
# NixOS system (pick your profile)
sudo nixos-rebuild switch --flake .#desktop-nixos
sudo nixos-rebuild switch --flake .#laptop-nixos
sudo nixos-rebuild switch --flake .#wsl-nixos

# Home Manager (pick your profile)
home-manager switch --flake .#desktop-nixos
home-manager switch --flake .#laptop-nixos
home-manager switch --flake .#wsl-nixos
```

### Fish Shell Shortcuts

Once configured, use these aliases:

```bash
nrs   # → sudo nixos-rebuild switch --flake ~/dotfiles#(hostname)
hrs   # → home-manager switch --flake ~/dotfiles#(hostname)
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
├── home/                     # 🏠 Home Manager modules
│   ├── shared.nix            # Common to ALL profiles
│   ├── fonts.nix             # Font configuration
│   ├── profiles/
│   │   ├── desktop.nix       # GUI apps + shared
│   │   └── wsl.nix           # Shared only (headless)
│   └── programs/
│       ├── fish.nix          # Shell config
│       ├── starship.nix      # Prompt
│       ├── vscode.nix        # Editor
│       ├── foot.nix          # Terminal
│       ├── alacritty.nix     # Alt terminal
│       ├── btop.nix          # System monitor
│       ├── cava.nix          # Audio visualizer
│       ├── micro.nix         # Text editor
│       └── fastfetch.nix     # System info
│
├── config/                   # ⚙️ App configuration files
│   ├── hypr/                 # Hyprland WM
│   ├── alacritty/            # Terminal
│   ├── btop/                 # System monitor
│   ├── cava/                 # Audio visualizer
│   ├── foot/                 # Terminal
│   ├── mako/                 # Notifications
│   ├── micro/                # Editor
│   └── rofi/                 # Launcher
│
├── pkgs/                     # 📦 Custom packages
│   └── spotify-adblock/
│
└── overlays/                 # 🔄 Nixpkgs overlays
```

---

## ⚙️ Key Configuration Highlights

### Desktop Features

```nix
# KDE Plasma 6 with Wayland
services.desktopManager.plasma6.enable = true;
services.displayManager.sddm.wayland.enable = true;

# NVIDIA with open drivers
hardware.nvidia.open = true;
hardware.nvidia.modesetting.enable = true;

# Drawing tablet support
hardware.opentabletdriver.enable = true;

```
---

## 🛠️ Common Commands

```fish
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

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

### Adding a New Program

1. Create `home/programs/myprogram.nix`:
```nix
{ config, pkgs, ... }:
{
  programs.myprogram = {
    enable = true;
    # ... options
  };
}
```

2. Import in the appropriate profile (`desktop.nix` for GUI, `shared.nix` for CLI).

### Adding GUI Apps to Desktop Only

Edit `home/profiles/desktop.nix`:
```nix
home.packages = with pkgs; [
  # Add your GUI apps here
  firefox
  obsidian
];
```

### Creating a New Host

1. Copy an existing host: `cp -r hosts/desktop hosts/myhost`
2. Update `hardware-configuration.nix` (generate with `nixos-generate-config`)
3. Add to `flake.nix`:
```nix
nixosConfigurations.myhost-nixos = mkSystem "myhost";
homeConfigurations.myhost-nixos = mkHome "myhost";
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Git tree is dirty" warning | Commit or stash changes before rebuild |
| Flake eval error | Run with `--show-trace` for details |
| GUI apps in WSL | Use `wsl-nixos` profile (intentionally headless) |
| NVIDIA issues | Check `hardware.nvidia.open` compatibility |

```fish
# Debug flake evaluation
nix build .#nixosConfigurations.desktop-nixos.config.system.build.toplevel --show-trace

# Check Home Manager news
home-manager news
```

---

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes Guide](https://nixos.wiki/wiki/Flakes)
- [Catppuccin Theme](https://catppuccin.com/)

---

<div align="center">

**[⬆ Back to Top](#️-nixos-dotfiles)**

Made with ❄️ and ☕ by [@AhmedAmrNabil](https://github.com/AhmedAmrNabil)

</div>
