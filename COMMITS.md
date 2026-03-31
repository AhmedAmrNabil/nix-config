# NixOS Commit Conventions

A consistent commit style for this config repo. Every commit follows:

```
<type>(<scope>): <short description>
```

The scope is always the **app, module, host, or input name** — lowercase, matching the directory or option name.

---

## Quick reference

| Type | What changed | Where |
|---|---|---|
| `flake` | flake inputs / flake.lock | `flake.nix`, `flake.lock` |
| `home` | added a new home-manager app or profile package | `home/apps/<app>/default.nix` (new), `home/profiles/*.nix` |
| `config` | changed options inside an existing home or system module | `home/apps/<app>/default.nix` (existing), `modules/**` |
| `dot` | edited a raw symlinked config file | `home/apps/<app>/<file>`, `config/hypr/*`, `config/mako/*`, `config/rofi/*` |
| `module` | created a new system module with an enable option | `modules/apps/<n>/default.nix` (new), `modules/core/<n>`, `modules/de/<n>` |
| `host` | changed a host configuration | `hosts/<host>/configuration.nix` |
| `pkg` | added or updated a custom derivation | `packages/<n>/default.nix` |
| `overlay` | added or updated an overlay | `overlays/<n>/default.nix` |

---

## Types in detail

### `flake` — flake inputs

Use when running `nix flake update` or changing a specific input in `flake.nix`.
Omit scope for a full lockfile update. Scope with the input name when only one input changed.

```
flake: update flake.lock
flake(nixpkgs): bump to 2025-03-28
flake(home-manager): follow nixpkgs input
```

---

### `home` — add a home-manager app or profile package

Use when **creating** a new `home/apps/<app>/` directory for the first time,
or when adding a package to `home.packages` inside a profile.

```
home(zoxide): add zoxide with fish integration
home(starship): add starship prompt
home(desktop): add obsidian and slack
home(shared): add localsend
```

> After the initial add, all further changes to that app use `config` or `dot`.

---

### `config` — modify an existing module or home-manager app

Use when changing **Nix options or packages** inside an already-existing module.
Covers `home/apps/<app>/default.nix`, `modules/apps/`, `modules/core/`, and `modules/de/`.

```
config(vscode): add vim keybindings extension
config(fish): add custom abbreviations
config(steam): add gamescope session package
config(steam): expose autoLogin option
config(nvidia): enable open kernel modules
config(hyprland): add xdg-portal package
config(boot): switch to systemd-boot
```

---

### `dot` — edit a symlinked config file

Use when editing the **raw content** of a file that gets symlinked into `$HOME` —
not the Nix that manages it, but the file itself.
Applies to `home/apps/<app>/<file>` and to files under `config/hypr/`, `config/mako/`, `config/rofi/`.

```
dot(vscode): enable minimap, set tab size to 2
dot(vscode): add keybinding for terminal split
dot(cava): tune gradient and bar width
dot(rofi): restyle catppuccin theme padding
dot(hyprland): add super+tab workspace switch bind
dot(hyprland): tune animation bezier curve
dot(hyprlock): add clock widget
dot(mako): update notification border radius
dot(open-tablet-driver): update Deco 01 V2 mapping
```

---

### `module` — create a new system module

Use **only** when creating a new file under `modules/` that exposes a
`lib.mkEnableOption` option. One-time commit per module.

```
module(tailscale): add tailscale module with firewall option
module(plymouth): add boot splash module
module(flydigictl): add flydigictl service module
```

> All subsequent changes to that module use `config(<name>)`.

---

### `host` — change a host configuration

Use for anything in `hosts/<host>/configuration.nix`:
toggling module options (`apps.steam.enable = true`),
adding host-specific system packages, mounts, networking, etc.

```
host(desktop): enable flydigictl and obs modules
host(desktop): add lutris to systemPackages
host(desktop): mount crucial SSD bind points
host(laptop): disable nvidia, enable tlp
host(wsl): enable wsl-specific networking
```

---

### `pkg` — add or update a custom package

Use for derivations written by hand under `packages/`.

```
pkg(flydigictl): add initial derivation
pkg(spotify-adblock): update to 1.0.4
pkg(gpu-screen-recorder-ui): fix missing build inputs
```

---

### `overlay` — add or update an overlay

Use for anything under `overlays/`.

```
overlay(xournalpp): patch default page templates
overlay(xournalpp): update to upstream 1.2.4
```

---

## Common ambiguities

**`config` vs `dot` for vscode**
- `config(vscode)` → you changed `programs.vscode.extensions` or an option in `home/apps/vscode/default.nix`
- `dot(vscode)` → you edited `settings.json` or `keybindings.json` directly

**`home` vs `host` for packages**
- `home(desktop)` → added to `home.packages` in `home/profiles/desktop.nix`
- `host(desktop)` → added to `environment.systemPackages` in `hosts/desktop/configuration.nix`

**`module` vs `config` for modules**
- `module(steam)` → the day you created `modules/apps/steam/default.nix`
- `config(steam)` → every change to that file after that day
