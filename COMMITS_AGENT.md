# NixOS commit convention — agent reference

## Format

```
<type>(<scope>): <short description in imperative mood, lowercase, no period>
```

Scope is always the app/module/host/input name, matching the directory or Nix option name exactly.

---

## Decision tree

To pick the correct type, answer these questions in order:

1. Did `flake.lock` or `flake.nix` inputs change? → **`flake`**
2. Is this a **new** file under `modules/`? → **`module`**
3. Is this a **new** `home/apps/<app>/` directory? → **`home`**
4. Is this a **new** package added to `home.packages` in `home/profiles/`? → **`home`** (scope = profile name)
5. Is this a change to `hosts/<host>/configuration.nix`? → **`host`**
6. Is this an edit to a **raw config/dotfile** (`*.json`, `*.conf`, `*.rasi`, `*.ini`, `config` with no extension)? → **`dot`**
7. Is this a change to a `default.nix` inside `home/apps/` or `modules/`? → **`config`**
8. Is this a new/changed derivation in `packages/`? → **`pkg`**
9. Is this a new/changed file in `overlays/`? → **`overlay`**

---

## Type definitions

### `flake`

**Trigger:** `flake.lock` changed, or `inputs` block in `flake.nix` changed.
**Scope:** omit for full update; use input name for single-input change.

```
flake: update flake.lock
flake(nixpkgs): bump to 2025-03-28
flake(home-manager): follow nixpkgs
```

---

### `module`

**Trigger:** new file created at `modules/apps/<n>/default.nix`, `modules/core/<n>/default.nix`, or `modules/de/<n>/default.nix` containing `lib.mkEnableOption`.
**Scope:** module directory name.
**Use once per module.** All subsequent edits to that file → `config`.

```
module(tailscale): add tailscale module with firewall option
module(plymouth): add boot splash module
module(flydigictl): add flydigictl service module
module(kde): add kde desktop environment module
```

---

### `home`

**Trigger A:** new directory `home/apps/<app>/` created for the first time.
**Trigger B:** package added to `home.packages` in `home/profiles/<profile>.nix`.
**Scope A:** app name.
**Scope B:** profile name (`desktop`, `laptop`, `shared`, `wsl`).

```
home(zoxide): add zoxide with fish integration
home(starship): add starship prompt
home(desktop): add obsidian and slack
home(shared): add localsend
home(laptop): add handbrake
```

---

### `config`

**Trigger A:** existing `home/apps/<app>/default.nix` edited (options, extensions, packages declared in Nix).
**Trigger B:** existing `modules/apps/<n>/default.nix`, `modules/core/<n>/default.nix`, or `modules/de/<n>/default.nix` edited.
**Scope:** app or module name.

```
config(vscode): add vim keybindings extension
config(fish): add custom abbreviations
config(alacritty): switch font to JetBrains Mono
config(steam): add gamescope session package
config(steam): expose autoLogin option
config(nvidia): enable open kernel modules
config(hyprland): add xdg-portal package
config(boot): switch to systemd-boot
config(fonts): add arabic fontconfig rule
```

---

### `dot`

**Trigger:** raw content of a symlinked file edited. These paths always trigger `dot`:
- `home/apps/<app>/<anything that is not default.nix>` (e.g. `settings.json`, `keybindings.json`, `config`, `*.rasi`)
- `config/hypr/<any file>`
- `config/mako/<any file>`
- `config/rofi/<any file>`

**Scope:** app the file belongs to (`vscode`, `cava`, `rofi`, `hyprland`, `hyprlock`, `mako`, `open-tablet-driver`).

```
dot(vscode): enable minimap, set tab size to 2
dot(vscode): add keybinding for terminal split
dot(cava): tune gradient and bar width
dot(rofi): restyle catppuccin theme padding
dot(hyprland): add super+tab workspace switch bind
dot(hyprland): tune animation bezier curve
dot(hyprlock): add clock widget
dot(mako): update notification border radius
dot(open-tablet-driver): update Deco 01 V2 axis mapping
```

---

### `host`

**Trigger:** `hosts/<host>/configuration.nix` edited. Includes: toggling `apps.<n>.enable`, `core.<n>.enable`, `de.<n>.enable`; adding to `environment.systemPackages`; changing mounts, networking, services, sysctl, pipewire config.
**Scope:** host name (`desktop`, `laptop`, `wsl`).

```
host(desktop): enable flydigictl and obs modules
host(desktop): add lutris to systemPackages
host(desktop): mount crucial SSD bind points
host(desktop): tune pipewire clock quantum to 32
host(laptop): disable nvidia, enable tlp
host(wsl): enable wsl networking module
```

---

### `pkg`

**Trigger:** file under `packages/<n>/` created or modified.
**Scope:** package directory name.

```
pkg(flydigictl): add initial derivation
pkg(spotify-adblock): update to 1.0.4
pkg(gpu-screen-recorder-ui): fix missing build inputs
pkg(wps-fonts): add wps office font package
```

---

### `overlay`

**Trigger:** file under `overlays/<n>/` created or modified.
**Scope:** overlay directory name.

```
overlay(xournalpp): patch default page templates
overlay(xournalpp): update to upstream 1.2.4
```

---

## Ambiguity rules (apply in order)

| Situation | Correct type |
|---|---|
| `home/apps/vscode/default.nix` changed | `config(vscode)` |
| `home/apps/vscode/settings.json` changed | `dot(vscode)` |
| `home/apps/vscode/keybindings.json` changed | `dot(vscode)` |
| `home/profiles/desktop.nix` — new package in `home.packages` | `home(desktop)` |
| `hosts/desktop/configuration.nix` — new package in `environment.systemPackages` | `host(desktop)` |
| `modules/apps/steam/default.nix` — file is new | `module(steam)` |
| `modules/apps/steam/default.nix` — file already existed | `config(steam)` |
| `config/hypr/hyprland.conf` changed | `dot(hyprland)` |
| `config/hypr/hyprlock.conf` changed | `dot(hyprlock)` |
| `config/rofi/colors.rasi` changed | `dot(rofi)` |
| `config/mako/config` changed | `dot(mako)` |
| Multiple files changed across one logical change | Use the type of the primary/most significant file |

---

## Message rules

- Imperative mood: "add", "update", "fix", "remove", "enable", "disable", "tune", "switch"
- Lowercase subject, no trailing period
- 72 characters max for the subject line
- If multiple things changed, list them comma-separated: `config(steam): add mangohud, enable gamemode`
- Do not use vague subjects like "update config" or "fix stuff" — name what changed
