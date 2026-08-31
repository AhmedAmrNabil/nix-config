# Nix Packages

This directory contains custom Nix package definitions exposed as outputs by this flake (`github:AhmedAmrNabil/nix-config#package-name`).

## Binary Cache

All packages in this directory are automatically built via GitHub Actions and cached to [Cachix](https://cachix.org). Pre-built binaries can be substituted directly to avoid building from source.

- **Cache URL:** `https://ahmed-amr.cachix.org`
- **Public Key:** `ahmed-amr.cachix.org-1:gwUGJSgbW4JiorIqExv1r9uujfyS5Blc8S6L34gxUl0=`

### Enabling the Cache

#### Using Cachix CLI

```bash
cachix use ahmed-amr
```

#### Via `nix.settings` (NixOS / Home Manager)

```nix
nix.settings = {
	substituters = [
		"https://ahmed-amr.cachix.org"
	];
	trusted-public-keys = [
		"ahmed-amr.cachix.org-1:gwUGJSgbW4JiorIqExv1r9uujfyS5Blc8S6L34gxUl0="
	];
};

```

## Usage

### Run Remotely

Run any package directly without cloning the repository:

```bash
nix run github:AhmedAmrNabil/nix-config#package-name
```

### Build Remotely

Build and produce a `./result` symlink in your current directory:

```bash
nix build github:AhmedAmrNabil/nix-config#package-name
```

### Local Development

If you have cloned the repository locally, run these commands from the repository root:

```bash
# Build locally
nix build .#package-name

# Run locally
nix run .#package-name
```
