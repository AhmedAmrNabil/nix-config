#!/usr/bin/env bash
set -euo pipefail

template_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

rev="$(
    jq -r '
    .nodes
    | to_entries[]
    | select(
        .value.original.type == "github"
        and .value.original.owner == "nixos"
        and .value.original.repo == "nixpkgs"
        and .value.original.ref == "nixos-26.05"
      )
    | .value.locked.rev
    ' flake.lock
)"

if [[ -z "$rev" || "$rev" == "null" ]]; then
    echo "Could not find nixpkgs nixos-26.05 in flake.lock" >&2
    exit 1
fi

sed "s/__NIXPKGS_REV__/$rev/g" \
"$template_dir/flake.nix.in" \
> "$template_dir/../../package/flake.nix"

echo "Generated $template_dir/flake.nix"
echo "nixpkgs revision: $rev"