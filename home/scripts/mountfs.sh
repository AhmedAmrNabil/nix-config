#!/usr/bin/env bash
set -euo pipefail

# this script is used inside live usb enviroment for 
# quick mounting the btrfs partition and its subvolumes, 
# as well as the efi partition

BTRFS_UUID="2b9d4cde-3908-427c-936f-ff16eebf8045"
BTRFS_DEV="/dev/disk/by-uuid/$BTRFS_UUID"
EFI_DEV="/dev/disk/by-uuid/A638-A2B0"
MNT="${1:-/mnt}"

echo "Mounting to $MNT..."

mount -o subvol=@ "$BTRFS_DEV" "$MNT"

for subvol in home nix persist swap; do
    mkdir -p "$MNT/$subvol"
    mount -o "subvol=@$subvol" "$BTRFS_DEV" "$MNT/$subvol"
done

mkdir -p "$MNT/boot"
mount "$EFI_DEV" "$MNT/boot"

echo "Done. Layout:"
findmnt --tree "$MNT"